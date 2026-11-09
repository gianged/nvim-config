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
            "<leader>ff",
            function()
                require("snacks").picker.files()
            end,
            desc = "Find files",
        },
        {
            "<leader>fg",
            function()
                require("snacks").picker.grep()
            end,
            desc = "Grep project",
        },
        {
            "<leader>fb",
            function()
                require("snacks").picker.buffers()
            end,
            desc = "Buffers",
        },
        {
            "<leader>fr",
            function()
                require("snacks").picker.resume()
            end,
            desc = "Resume last picker",
        },
    },
}
