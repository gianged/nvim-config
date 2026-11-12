return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        picker = {
            enabled = true,
            sources = {
                files = { hidden = true },
                grep = { hidden = true },
            },
        },
    },
    keys = {
        {
            "<leader>pf",
            function()
                require("snacks").picker.files()
            end,
            desc = "Find files",
        },
        {
            "<M-t>",
            function()
                require("snacks").picker.files()
            end,
            desc = "Find files",
        },
        {
            "<leader>pg",
            function()
                require("snacks").picker.grep()
            end,
            desc = "Grep project",
        },
        {
            "<leader>pb",
            function()
                require("snacks").picker.buffers()
            end,
            desc = "Buffers",
        },
        {
            "<leader>pr",
            function()
                require("snacks").picker.resume()
            end,
            desc = "Resume last picker",
        },
    },
}
