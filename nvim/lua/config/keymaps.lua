local map = vim.keymap.set

-- Search
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Windows
map("n", "<M-u>", "<C-w>k", { desc = "Focus upper window" })
map("n", "<M-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<M-j>", "<C-w>j", { desc = "Focus lower window" })
map("n", "<M-k>", "<C-w>l", { desc = "Focus right window" })

-- Editing
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })
