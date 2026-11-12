local function run_all_steps(group)
    local services = {}
    for _, entry in ipairs(group.entries) do
        table.insert(services, {
            name = entry.name,
            cmd = group.build_all_cmd and { entry.program } or entry.run_cmd,
            cwd = entry.cwd,
        })
    end
    if not group.build_all_cmd then
        return { services }
    end
    return { { name = "build", cmd = group.build_all_cmd, cwd = group.root }, services }
end

local function command_template(name, cmd, cwd, hide)
    return {
        name = name,
        hide = hide,
        builder = function()
            return { name = name, cmd = cmd, cwd = cwd }
        end,
    }
end

local function group_templates(group, multi)
    local templates = {}
    for _, entry in ipairs(group.entries) do
        table.insert(templates, command_template("run " .. entry.name, entry.run_cmd, entry.cwd, false))
        if entry.build_cmd then
            table.insert(templates, command_template("build " .. entry.name, entry.build_cmd, entry.cwd, true))
        end
    end
    if group.build_all_cmd then
        local name = "build all " .. group.lang
        table.insert(templates, command_template(name, group.build_all_cmd, group.root, true))
    end
    if #group.entries >= 2 then
        local name = ("run all%s (%d)"):format(multi and (" " .. group.lang) or "", #group.entries)
        table.insert(templates, {
            name = name,
            builder = function()
                return {
                    name = name,
                    cwd = group.root,
                    strategy = { "orchestrator", tasks = vim.deepcopy(run_all_steps(group)) },
                }
            end,
        })
    end
    return templates
end

local entrypoint_provider = {
    name = "entrypoints",
    generator = function(search, cb)
        require("entrypoints").discover(search.dir, function(groups, errors)
            for _, err in ipairs(errors) do
                vim.notify(err, vim.log.levels.WARN, { title = "entrypoints" })
            end
            local templates = {}
            for _, group in ipairs(groups) do
                vim.list_extend(templates, group_templates(group, #groups > 1))
            end
            cb(templates)
        end)
    end,
}

local function project_task(root, task)
    if task.cmd then
        return {
            name = task.name,
            cmd = task.cmd,
            cwd = task.cwd and vim.fs.joinpath(root, task.cwd) or root,
            env = task.env,
        }
    end
    local steps = vim.deepcopy(task.sequence or { task.parallel })
    return { name = task.name, cwd = root, strategy = { "orchestrator", tasks = steps } }
end

local project_provider = {
    name = "project",
    generator = function(search)
        local templates = {}
        for _, project in ipairs(require("project").containing(search.dir)) do
            for _, task in ipairs(project.tasks) do
                table.insert(templates, {
                    name = task.name,
                    builder = function()
                        return project_task(project.root, task)
                    end,
                })
            end
        end
        return templates
    end,
}

local function restart_last()
    local overseer = require("overseer")
    local tasks = overseer.list_tasks({ sort = require("overseer.task_list").sort_newest_first })
    if #tasks == 0 then
        vim.notify("No tasks", vim.log.levels.WARN)
        return
    end
    overseer.run_action(tasks[1], "restart")
end

return {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerShell", "OverseerTaskAction" },
    opts = {
        dap = false,
        form = { border = "rounded" },
        task_win = { border = "rounded" },
    },
    config = function(_, opts)
        local overseer = require("overseer")
        overseer.setup(opts)
        overseer.register_template(entrypoint_provider)
        overseer.register_template(project_provider)
    end,
    keys = {
        { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Run task" },
        { "<leader>rs", "<cmd>OverseerShell<cr>", desc = "Run shell command as task" },
        { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
        { "<leader>rl", restart_last, desc = "Restart last task" },
        { "<leader>ra", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
    },
}
