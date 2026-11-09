local TIMEOUT_MS = 1000
local CLANG_FORMAT_FILES = { ".clang-format", "_clang-format" }
local CLANG_FALLBACK_STYLE = "--style={BasedOnStyle: LLVM, IndentWidth: 4, AccessModifierOffset: -4}"

local format_on_save_ft = {
    rust = true,
    c = true,
    cpp = true,
    go = true,
    java = true,
    python = true,
    typescript = true,
    typescriptreact = true,
    javascript = true,
    javascriptreact = true,
    lua = true,
}

local ts_import_actions = {
    { kind = "source.removeUnusedImports.ts", skip_on_errors = true },
    { kind = "source.organizeImports.ts" },
}

local import_actions = {
    typescript = ts_import_actions,
    typescriptreact = ts_import_actions,
    javascript = ts_import_actions,
    javascriptreact = ts_import_actions,
}

local default_import_actions = { { kind = "source.organizeImports" } }

local ts_ls_only = { lsp_format = "fallback", name = "ts_ls" }

local function kind_covers(parent, kind)
    return kind == parent or vim.startswith(kind, parent .. ".")
end

local function may_offer(client, kind)
    local provider = client.server_capabilities.codeActionProvider
    local kinds = type(provider) == "table" and provider.codeActionKinds
    if not kinds then
        return true
    end
    for _, advertised in ipairs(kinds) do
        if advertised ~= "" and (kind_covers(advertised, kind) or kind_covers(kind, advertised)) then
            return true
        end
    end
    return false
end

local function document_range(buf, encoding)
    local last = vim.api.nvim_buf_line_count(buf) - 1
    local text = vim.api.nvim_buf_get_lines(buf, last, last + 1, true)[1]
    return {
        start = { line = 0, character = 0 },
        ["end"] = { line = last, character = vim.str_utfindex(text, encoding) },
    }
end

local function find_action(client, buf, kind)
    local params = {
        textDocument = vim.lsp.util.make_text_document_params(buf),
        range = document_range(buf, client.offset_encoding),
        context = { only = { kind }, diagnostics = {} },
    }
    local resp, err = client:request_sync("textDocument/codeAction", params, TIMEOUT_MS, buf)
    if err then
        vim.notify(("organize imports: %s %s"):format(client.name, err), vim.log.levels.WARN)
        return nil
    end
    for _, action in ipairs(resp and resp.result or {}) do
        if action.kind and kind_covers(kind, action.kind) and not action.disabled then
            return action
        end
    end
end

local function resolve(client, buf, action)
    if action.edit or action.command or not client:supports_method("codeAction/resolve", buf) then
        return action
    end
    local resp = client:request_sync("codeAction/resolve", action, TIMEOUT_MS, buf)
    return resp and resp.result or action
end

local function run_command(client, buf, command)
    local fn = client.commands[command.command] or vim.lsp.commands[command.command]
    if fn then
        fn(command, { bufnr = buf, client_id = client.id })
    else
        client:request_sync("workspace/executeCommand", command, TIMEOUT_MS, buf)
    end
end

local function apply_import_action(client, buf, kind)
    local action = find_action(client, buf, kind)
    if not action then
        return false
    end
    action = resolve(client, buf, action)
    if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
    if action.command then
        run_command(client, buf, action.command)
    end
    return true
end

local function has_errors(buf)
    return #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR }) > 0
end

local function organize_imports(buf)
    local clients = vim.lsp.get_clients({ bufnr = buf, method = "textDocument/codeAction" })
    for _, step in ipairs(import_actions[vim.bo[buf].filetype] or default_import_actions) do
        if not (step.skip_on_errors and has_errors(buf)) then
            for _, client in ipairs(clients) do
                if may_offer(client, step.kind) and apply_import_action(client, buf, step.kind) then
                    break
                end
            end
        end
    end
end

local function clang_style_args(_, ctx)
    local found = vim.fs.find(CLANG_FORMAT_FILES, { upward = true, path = ctx.dirname })
    return #found == 0 and { CLANG_FALLBACK_STYLE } or {}
end

local function toggle_format_on_save()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify("Format on save " .. (vim.g.disable_autoformat and "off" or "on"))
end

return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "ConformInfo",
    opts = {
        formatters_by_ft = {
            c = { "clang_format" },
            cpp = { "clang_format" },
            lua = { "stylua", lsp_format = "never" },
            typescript = ts_ls_only,
            typescriptreact = ts_ls_only,
            javascript = ts_ls_only,
            javascriptreact = ts_ls_only,
        },
        formatters = {
            clang_format = { prepend_args = clang_style_args },
        },
        default_format_opts = {
            lsp_format = "fallback",
            timeout_ms = TIMEOUT_MS,
        },
    },
    config = function(_, opts)
        local conform = require("conform")
        conform.setup(opts)
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("config_format", { clear = true }),
            desc = "Organize imports, then format",
            callback = function(args)
                if vim.g.disable_autoformat or not format_on_save_ft[vim.bo[args.buf].filetype] then
                    return
                end
                organize_imports(args.buf)
                conform.format({ bufnr = args.buf })
            end,
        })

        vim.keymap.set("n", "<leader>uf", toggle_format_on_save, { desc = "Toggle format on save" })
    end,
}
