local function nav_hunk(key, direction)
    return function()
        if vim.wo.diff then
            vim.cmd.normal({ key, bang = true })
        else
            require("gitsigns").nav_hunk(direction)
        end
    end
end

local function on_attach(buf)
    local gitsigns = require("gitsigns")

    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    map("n", "]c", nav_hunk("]c", "next"), "Next git hunk")
    map("n", "[c", nav_hunk("[c", "prev"), "Previous git hunk")
    map("n", "<leader>gp", gitsigns.preview_hunk, "Preview git hunk")
    map("n", "<leader>gb", function()
        gitsigns.blame_line({ full = true })
    end, "Blame line")
    map("n", "<leader>gB", gitsigns.toggle_current_line_blame, "Toggle line blame")
    map("n", "<leader>gq", function()
        gitsigns.setqflist("all")
    end, "Git hunks to quickfix")
    map({ "o", "x" }, "ih", gitsigns.select_hunk, "Git hunk")
end

return {
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            on_attach = on_attach,
        },
    },
    {
        "NeogitOrg/neogit",
        cmd = "Neogit",
        dependencies = { "esmuellert/codediff.nvim", "folke/snacks.nvim" },
        opts = {
            diff_viewer = "codediff",
            integrations = {
                codediff = true,
                snacks = true,
                diffview = false,
            },
            graph_style = "unicode",
        },
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git panel" },
        },
    },
    {
        "esmuellert/codediff.nvim",
        cmd = "CodeDiff",
        build = ":CodeDiff install",
        opts = {
            keymaps = {
                view = {
                    stage_hunk = false,
                    unstage_hunk = false,
                    discard_hunk = false,
                },
                conflict = {
                    accept_incoming = "<leader>gct",
                    accept_current = "<leader>gco",
                    accept_both = "<leader>gcb",
                    discard = "<leader>gcx",
                    accept_all_incoming = "<leader>gcT",
                    accept_all_current = "<leader>gcO",
                    accept_all_both = "<leader>gcB",
                    discard_all = "<leader>gcX",
                },
            },
        },
        keys = {
            { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Git diff view" },
            { "<leader>gh", "<cmd>CodeDiff history %<cr>", desc = "Git file history" },
            { "<leader>gh", ":CodeDiff history<cr>", mode = "x", desc = "Git line history" },
        },
    },
}
