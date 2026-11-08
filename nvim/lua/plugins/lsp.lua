local mason_servers = { "gopls", "jdtls", "basedpyright", "ruff", "ts_ls", "eslint", "lua_ls" }
local system_servers = { "rust_analyzer", "clangd" }

return {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "mason-org/mason.nvim", cmd = "Mason", opts = {} },
        "neovim/nvim-lspconfig",
    },
    opts = {
        ensure_installed = mason_servers,
    },
    config = function(_, opts)
        require("mason-lspconfig").setup(opts)
        vim.lsp.enable(system_servers)

        vim.diagnostic.config({
            virtual_lines = { current_line = true },
        })

        vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("config_lsp", { clear = true }),
            desc = "LSP buffer keymaps",
            callback = function(args)
                local buf = args.buf
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
                vim.keymap.set("n", "<leader>uh", function()
                    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
                    vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
                end, { buffer = buf, desc = "Toggle inlay hints" })
            end,
        })
    end,
}
