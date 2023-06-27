--Keybindings for debugging
vim.keymap.set('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>")
vim.keymap.set('n', '<F6>', ":lua require'dap'.step_over()<CR>")
vim.keymap.set('n', '<F7>', ":lua require'dap'.step_into()<CR>")
vim.keymap.set('n', '<F8>', ":lua require'dap'.step_out()<CR>")


-- Setup dap & dapui with defaults
--require('dap').setup()
require('dapui').setup()
require('dap-python').setup()
require("nvim-dap-virtual-text").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
