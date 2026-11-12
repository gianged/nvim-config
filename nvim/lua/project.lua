local TASK_KINDS = { "cmd", "parallel", "sequence" }
local DEBUG_KINDS = { "type", "compound" }

local M = {}

local projects = {}

local function validate(entry, kinds, what, root)
    if type(entry.name) ~= "string" then
        error(("project %s: %s without a string name"):format(root, what), 0)
    end
    local count = 0
    for _, kind in ipairs(kinds) do
        if entry[kind] ~= nil then
            count = count + 1
        end
    end
    if count ~= 1 then
        local msg = "project %s: %s '%s' needs exactly one of %s"
        error(msg:format(root, what, entry.name, table.concat(kinds, ", ")), 0)
    end
end

function M.setup(spec)
    local source = debug.getinfo(2, "S").source:gsub("^@", "")
    local root = vim.fs.dirname(vim.fs.abspath(source))
    local tasks = spec.tasks or {}
    local debug_entries = spec.debug or {}
    for _, task in ipairs(tasks) do
        validate(task, TASK_KINDS, "task", root)
    end
    for _, entry in ipairs(debug_entries) do
        validate(entry, DEBUG_KINDS, "debug entry", root)
    end
    projects[root] = { root = root, tasks = tasks, debug = debug_entries }
end

function M.containing(dir)
    local found = {}
    for root, project in pairs(projects) do
        if vim.fs.relpath(root, dir) then
            table.insert(found, project)
        end
    end
    return found
end

return M
