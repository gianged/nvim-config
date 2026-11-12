local OWN_PROVIDERS = { entrypoints = true, project = true }

local LANG_CONFIG = {
    rust = function(entry)
        return {
            type = "lldb",
            request = "launch",
            program = entry.program,
            cwd = entry.cwd,
            terminal = "integrated",
            sourceLanguages = { "rust" },
        }
    end,
}

local M = {}

local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.ERROR, { title = "debug" })
end

local function search_dir(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name ~= "" and vim.bo[bufnr].buftype == "" then
        return vim.fs.dirname(name)
    end
    return vim.fn.getcwd()
end

local function await_groups(dir)
    local co = coroutine.running()
    local yielded, result = false, nil
    require("entrypoints").discover(dir, function(groups, errors)
        for _, err in ipairs(errors) do
            notify(err, vim.log.levels.WARN)
        end
        result = groups
        if yielded then
            coroutine.resume(co)
        end
    end)
    if result == nil then
        yielded = true
        coroutine.yield()
    end
    return result
end

local function entry_targets(groups)
    local configs, compounds = {}, {}
    for _, group in ipairs(groups) do
        local to_config = LANG_CONFIG[group.lang]
        if to_config then
            local members = {}
            for _, entry in ipairs(group.entries) do
                local config = to_config(entry)
                config.name = "debug " .. entry.name
                table.insert(members, vim.deepcopy(config))
                if entry.build_cmd then
                    config.preLaunchTask = "build " .. entry.name
                end
                table.insert(configs, config)
            end
            if #members >= 2 then
                local suffix = #groups > 1 and (" " .. group.lang) or ""
                table.insert(compounds, {
                    name = ("debug all%s (%d)"):format(suffix, #members),
                    preLaunchTask = group.build_all_cmd and ("build all " .. group.lang) or nil,
                    members = members,
                })
            end
        end
    end
    return configs, compounds
end

local function resolve(root, path)
    if path == nil or vim.startswith(path, "/") or vim.startswith(path, "${") then
        return path
    end
    return vim.fs.joinpath(root, path)
end

local function project_targets(dir)
    local configs, compounds = {}, {}
    for _, project in ipairs(require("project").containing(dir)) do
        for _, entry in ipairs(project.debug) do
            if entry.compound then
                table.insert(compounds, {
                    name = entry.name,
                    preLaunchTask = entry.preLaunchTask,
                    members = entry.compound,
                })
            else
                local config = vim.deepcopy(entry)
                config.program = resolve(project.root, config.program)
                config.cwd = resolve(project.root, config.cwd) or project.root
                table.insert(configs, config)
            end
        end
    end
    return configs, compounds
end

local function provider_configs(bufnr)
    local configs = {}
    local providers = require("dap").providers.configs
    local keys = vim.tbl_keys(providers)
    table.sort(keys)
    for _, key in ipairs(keys) do
        if not OWN_PROVIDERS[key] then
            vim.list_extend(configs, providers[key](bufnr))
        end
    end
    return configs
end

local function run_task(name, on_success)
    require("overseer").run_task({ name = name, autostart = false }, function(task, err)
        if not task then
            notify(("preLaunchTask '%s' not found: %s"):format(name, err or ""))
            return
        end
        task:subscribe("on_complete", function(_, status)
            if status == "SUCCESS" then
                vim.schedule(on_success)
            else
                notify(("preLaunchTask '%s' failed"):format(name))
            end
            return true
        end)
        task:start()
    end)
end

local function start_members(compound, configs)
    local by_name = {}
    for _, config in ipairs(configs) do
        by_name[config.name] = by_name[config.name] or config
    end
    local dap = require("dap")
    for _, member in ipairs(compound.members) do
        local config = type(member) == "table" and member or by_name[member]
        if config then
            dap.run(config, { new = true })
        else
            notify(("compound '%s': no debug config named '%s'"):format(compound.name, member))
        end
    end
end

local function run_compound(compound, configs)
    if compound.preLaunchTask then
        run_task(compound.preLaunchTask, function()
            start_members(compound, configs)
        end)
    else
        start_members(compound, configs)
    end
end

local function format_item(item)
    return item.compound and (item.name .. "  [compound]") or item.name
end

function M.register()
    local providers = require("dap").providers.configs
    providers.entrypoints = function(bufnr)
        return (entry_targets(await_groups(search_dir(bufnr))))
    end
    providers.project = function(bufnr)
        return (project_targets(search_dir(bufnr)))
    end
end

function M.pick()
    local bufnr = vim.api.nvim_get_current_buf()
    require("dap.async").run(function()
        local dir = search_dir(bufnr)
        local configs, compounds = entry_targets(await_groups(dir))
        local own_configs, own_compounds = project_targets(dir)
        vim.list_extend(configs, own_configs)
        vim.list_extend(compounds, own_compounds)
        vim.list_extend(configs, provider_configs(bufnr))

        local items = {}
        for _, config in ipairs(configs) do
            table.insert(items, { name = config.name, config = config })
        end
        for _, compound in ipairs(compounds) do
            table.insert(items, { name = compound.name, compound = compound })
        end
        if #items == 0 then
            notify("No debug targets found", vim.log.levels.WARN)
            return
        end
        vim.schedule(function()
            vim.ui.select(items, { prompt = "Debug", format_item = format_item }, function(item)
                if not item then
                    return
                elseif item.compound then
                    run_compound(item.compound, configs)
                else
                    require("dap").run(item.config, { new = true })
                end
            end)
        end)
    end)
end

function M.continue()
    local dap = require("dap")
    if dap.session() then
        dap.continue()
    else
        M.pick()
    end
end

function M.restart()
    local dap = require("dap")
    local session = dap.session()
    if not session then
        notify("No debug session", vim.log.levels.WARN)
        return
    end
    local config = session.config
    dap.terminate({
        on_done = vim.schedule_wrap(function()
            dap.run(config, { new = true })
        end),
    })
end

return M
