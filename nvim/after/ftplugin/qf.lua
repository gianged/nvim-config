vim.keymap.set("n", "<CR>", function()
    if require("config.peek").is_peek_qf() then
        return "<Cmd>lua require('config.peek').open_qf_item()<CR>"
    end
    return "<CR>"
end, { buffer = true, expr = true, desc = "Open entry (peek for LSP lists)" })
