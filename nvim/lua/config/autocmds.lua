local group = vim.api.nvim_create_augroup("config", { clear = true })

-- Yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    desc = "Flash yanked text",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Reload
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermLeave" }, {
    group = group,
    desc = "Reload buffers changed on disk",
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd.checktime()
        end
    end,
})
