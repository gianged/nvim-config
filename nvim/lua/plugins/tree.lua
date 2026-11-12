local function ranks(names)
    local rank = {}
    for i, name in ipairs(names) do
        rank[name] = i
    end
    return rank
end

local module_rules = {
    { ext = ".rs", entries = ranks({ "main.rs", "lib.rs", "mod.rs" }) },
    { ext = ".lua", entries = ranks({ "init.lua" }) },
}

local function find_rule(nodes)
    for _, rule in ipairs(module_rules) do
        for _, node in ipairs(nodes) do
            if node.type ~= "directory" and vim.endswith(node.name, rule.ext) then
                return rule
            end
        end
    end
end

local function sort_key(node, rule)
    local name = node.name
    if node.type == "directory" then
        return { 2, 0, name:lower(), 1 }
    end
    local entry = rule.entries[name]
    if entry then
        return { 1, entry, "", 0 }
    end
    if vim.endswith(name, rule.ext) then
        name = name:sub(1, -#rule.ext - 1)
    end
    return { 2, 0, name:lower(), 0 }
end

local function module_sorter(nodes)
    local rule = find_rule(nodes)
    if not rule then
        return "name"
    end
    local keys = {}
    for _, node in ipairs(nodes) do
        keys[node] = sort_key(node, rule)
    end
    table.sort(nodes, function(a, b)
        local ka, kb = keys[a], keys[b]
        for i = 1, #ka do
            if ka[i] ~= kb[i] then
                return ka[i] < kb[i]
            end
        end
        return false
    end)
end

return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        sort = { sorter = module_sorter },
        view = { width = 40 },
        filters = { custom = { "^\\.git$" } },
        diagnostics = { enable = true, show_on_dirs = true },
        update_focused_file = { enable = true },
        actions = {
            open_file = {
                window_picker = {
                    picker = function()
                        return require("config.peek").tree_target()
                    end,
                },
            },
        },
    },
    keys = {
        {
            "<leader>e",
            function()
                require("nvim-tree.api").tree.toggle({ find_file = true })
            end,
            desc = "Toggle file tree",
        },
        {
            "<M-e>",
            function()
                require("nvim-tree.api").tree.toggle({ find_file = true })
            end,
            desc = "Toggle file tree",
        },
    },
}
