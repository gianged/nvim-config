-- File explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Icons
vim.g.have_nerd_font = true

-- Display
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.wrap = false

-- Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Windows
vim.o.splitright = true
vim.o.splitbelow = true

-- Behaviour
vim.o.undofile = true
vim.o.updatetime = 250

-- Project config: .nvim.lua in cwd and parents, gated by :trust
vim.o.exrc = true

-- Clipboard: deferred until after startup
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)
