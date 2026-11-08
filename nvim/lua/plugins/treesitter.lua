local parsers = {
    "rust", "c", "cpp", "java", "go", "gomod", "python", "typescript", "tsx", "javascript",
    "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "bash", "json", "toml", "yaml",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        ts.install(parsers)

        local available = {}
        for _, lang in ipairs(ts.get_available()) do
            available[lang] = true
        end

        local function start(buf, lang)
            if vim.api.nvim_buf_is_valid(buf) then
                pcall(vim.treesitter.start, buf, lang)
            end
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
            desc = "Start treesitter, install missing parser",
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang or not available[lang] then
                    return
                end
                if vim.list_contains(ts.get_installed(), lang) then
                    start(args.buf, lang)
                    return
                end
                ts.install(lang):await(function()
                    vim.schedule(function()
                        start(args.buf, lang)
                    end)
                end)
            end,
        })
    end,
}
