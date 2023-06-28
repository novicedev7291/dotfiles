-- Set nop for arrow keys
vim.keymap.set('n', '<up>', '<nop>', opts)
vim.keymap.set('n', '<down>', '<nop>', opts)
vim.keymap.set('i', '<up>', '<nop>', opts)
vim.keymap.set('i', '<down>', '<nop>', opts)
vim.keymap.set('i', '<left>', '<nop>', opts)
vim.keymap.set('i', '<right>', '<nop>', opts)

-- Alias for :Ex - opens netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move the selected/current line(s) up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- This pins the current line and combine below lines as
-- with current line
vim.keymap.set("n", "J", "mzJ`z")

-- Keeps the search item in middle of screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- copy current and paste, keeping the word to be pasted again
vim.keymap.set("x", "<leader>p", "\"_dP")

-- copy the yanked content to clipboard register
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "Q", "<nop>")

-- formatting
vim.keymap.set("n", "<leader>f", function() 
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<left><left><left>")

--For nvim window increase decrease, these 
--are mentioned in neovim docs
vim.keymap.set("n", "<leader>h", "<C-w><")
vim.keymap.set("n", "<leader>l", "<C-w>>")
vim.keymap.set("n", "<leader>j", "<C-w>-")
vim.keymap.set("n", "<leader>k", "<C-w>+")
