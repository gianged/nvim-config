local mason_servers = { "gopls", "jdtls", "basedpyright", "ruff", "ts_ls", "eslint", "lua_ls" }
local system_servers = { "rust_analyzer", "clangd" }

local import_patterns = {
    "^%s*use%s",
    "^%s*import%s",
    "^%s*from%s.+%simport%s",
    "^%s*#%s*include",
}

local function is_import(text)
    for _, pattern in ipairs(import_patterns) do
        if text:find(pattern) then
            return true
        end
    end
    return false
end

local function references_without_imports()
    vim.lsp.buf.references({ includeDeclaration = false }, {
        on_list = function(list)
            local items = vim.tbl_filter(function(item)
                return not is_import(item.text)
            end, list.items)
            require("config.peek").set_qflist(list.title, items)
            vim.cmd.copen()
        end,
    })
end

return {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "mason-org/mason.nvim", lazy = false, opts = {} },
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
        vim.lsp.inlay_hint.enable(true)

        local peek = require("config.peek")
        peek.setup()

        vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })
        vim.keymap.set("n", "<leader>wp", peek.promote, { desc = "Pin peek window into origin" })
        vim.keymap.set("n", "<C-p>", peek.promote, { desc = "Pin peek window into origin" })
        vim.keymap.set("n", "<M-]>", peek.back, { desc = "Previous peek location" })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("config_lsp", { clear = true }),
            desc = "LSP buffer keymaps",
            callback = function(args)
                local buf = args.buf
                vim.keymap.set(
                    "n",
                    "gd",
                    peek.open(vim.lsp.buf.definition),
                    { buffer = buf, desc = "Go to definition (peek)" }
                )
                vim.keymap.set(
                    "n",
                    "<C-]>",
                    peek.open(vim.lsp.buf.definition),
                    { buffer = buf, desc = "Go to definition (peek)" }
                )
                vim.keymap.set(
                    "n",
                    "grt",
                    peek.open(vim.lsp.buf.type_definition),
                    { buffer = buf, desc = "Go to type definition (peek)" }
                )
                vim.keymap.set(
                    "n",
                    "gri",
                    peek.open(vim.lsp.buf.implementation),
                    { buffer = buf, desc = "Go to implementation (peek)" }
                )
                vim.keymap.set(
                    "n",
                    "grr",
                    references_without_imports,
                    { buffer = buf, desc = "References without imports" }
                )
                vim.keymap.set("n", "<leader>uh", function()
                    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
                    vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
                end, { buffer = buf, desc = "Toggle inlay hints" })
            end,
        })
    end,
}
