local tffiletype = vim.api.nvim_create_augroup("TfFileType", {})
vim.api.nvim_create_autocmd('BufNewFile', {
    pattern = {'*.tf','*.tfvars'},
    command = 'set ft=terraform',
    group = tffiletype
})

vim.api.nvim_create_autocmd('BufRead', {
    pattern = {'*.tf','*.tfvars'},
    command = 'set ft=terraform',
    group = tffiletype
})
