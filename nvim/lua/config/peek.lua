local M = {}

local owned = {}

local goto_peek, push, find_peek, open_peek, show, qf_bufs

function M.setup()
    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("config_peek", { clear = true }),
        desc = "Clean peek when its origin window changes file",
        callback = function()
            local peek = find_peek()
            if peek and vim.w[peek].peek_origin == vim.api.nvim_get_current_win() then
                vim.schedule(M.cleanup)
            end
        end,
    })
end

function M.open(lsp_fn)
    return function()
        lsp_fn({
            on_list = function(list)
                local items = list.items
                if #items == 0 then
                    return
                end
                if #items > 1 then
                    M.set_qflist(list.title, items)
                    vim.cmd.copen()
                    return
                end
                goto_peek(items[1])
            end,
        })
    end
end

function M.set_qflist(title, items)
    vim.fn.setqflist({}, " ", { title = title, items = items, context = { peek = true } })
end

function M.is_peek_qf()
    if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].loclist == 1 then
        return false
    end
    local ctx = vim.fn.getqflist({ context = 0 }).context
    return type(ctx) == "table" and ctx.peek == true
end

function M.open_qf_item()
    local idx = vim.fn.line(".")
    local item = vim.fn.getqflist()[idx]
    if not item or item.bufnr == 0 then
        return
    end
    vim.fn.setqflist({}, "a", { idx = idx })
    vim.cmd("wincmd p")
    goto_peek(item)
end

function M.promote()
    local peek = find_peek()
    if not peek then
        return
    end
    local origin = vim.w[peek].peek_origin
    if not (origin and vim.api.nvim_win_is_valid(origin)) then
        vim.w[peek].peek = nil
        return
    end
    local buf = vim.api.nvim_win_get_buf(peek)
    local view = vim.api.nvim_win_call(peek, vim.fn.winsaveview)
    vim.api.nvim_win_close(peek, false)
    vim.api.nvim_set_current_win(origin)
    vim.api.nvim_win_set_buf(origin, buf)
    vim.fn.winrestview(view)
    M.cleanup()
end

function M.back()
    local peek = find_peek()
    if not peek then
        return
    end
    local stack = vim.w[peek].peek_stack or {}
    local item = table.remove(stack)
    while item and not vim.api.nvim_buf_is_valid(item.bufnr) do
        item = table.remove(stack)
    end
    vim.w[peek].peek_stack = stack
    if item then
        show(peek, item)
    end
end

function M.tree_target()
    local win = vim.fn.win_getid(vim.fn.winnr("#"))
    if vim.w[win].peek then
        win = vim.w[win].peek_origin or -1
    end
    if win > 0 and vim.api.nvim_win_is_valid(win) and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "" then
        return win
    end
    return -1
end

function M.cleanup()
    local peek = find_peek()
    if peek then
        vim.api.nvim_win_close(peek, false)
    end
    local in_qf = qf_bufs()
    for buf in pairs(owned) do
        if not vim.api.nvim_buf_is_valid(buf) then
            owned[buf] = nil
        elseif vim.bo[buf].modified or #vim.fn.win_findbuf(buf) > 0 then
            owned[buf] = nil
        elseif not in_qf[buf] then
            owned[buf] = nil
            vim.api.nvim_buf_delete(buf, {})
        end
    end
end

function goto_peek(item)
    local cur = vim.api.nvim_get_current_win()
    local peek = find_peek()
    if peek then
        push(peek)
    else
        peek = open_peek()
    end
    if cur ~= peek then
        vim.w[peek].peek_origin = cur
    end
    show(peek, item)
end

function push(win)
    local stack = vim.w[win].peek_stack or {}
    local pos = vim.api.nvim_win_get_cursor(win)
    table.insert(stack, { bufnr = vim.api.nvim_win_get_buf(win), lnum = pos[1], col = pos[2] + 1 })
    vim.w[win].peek_stack = stack
end

function find_peek()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.w[win].peek then
            return win
        end
    end
end

function open_peek()
    vim.cmd("rightbelow vsplit")
    local win = vim.api.nvim_get_current_win()
    vim.w[win].peek = true
    return win
end

function show(win, item)
    vim.api.nvim_set_current_win(win)
    vim.cmd("normal! m'")
    local buf = (item.bufnr and item.bufnr ~= 0) and item.bufnr or vim.fn.bufadd(item.filename)
    if not vim.api.nvim_buf_is_loaded(buf) then
        owned[buf] = true
    end
    vim.cmd.buffer(buf)
    vim.api.nvim_win_set_cursor(win, { item.lnum, item.col - 1 })
    vim.cmd("normal! zv")
end

function qf_bufs()
    local set = {}
    for _, entry in ipairs(vim.fn.getqflist()) do
        set[entry.bufnr] = true
    end
    return set
end

return M
