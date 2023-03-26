-- Map leader key to space
vim.g.mapleader = " "

vim.o.guicursor = ""

-- Make line numbers default
vim.o.number = true

-- Make relative line numbers for easier jump
vim.o.relativenumber = true

-- Enable termguicolors, enable 24-bit RGB color TUI
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect,noinsert,preview'

-- Set the number of lines to be visible above and below of cursor always
vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.o.colorcolumn = "80"
-- vim.o.isfname:append("@-@")

vim.o.hlsearch = false
vim.o.incsearch = true

-- Set the indentation to follow
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.autoindent = true

vim.o.wrap = false

vim.o.updatetime = 50
