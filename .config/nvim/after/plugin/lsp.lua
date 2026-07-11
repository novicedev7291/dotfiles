local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local cmp_mappings = cmp.mapping.preset.insert({
    ['C-p'] = cmp.mapping.select_prev_item(cmp_select),
    ['C-n'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})
local cmp_completion = {
    autocomplete = false
    --    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
}

cmp.setup({
    completion = cmp_completion,
    mapping = cmp_mappings,
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" }
    }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set('n', '<C-l>', function() vim.diagnostic.setloclist() end, opts)
end

vim.lsp.config('*', {
    capabilities = capabilities,
})

require('mason').setup()
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    -- ensure_installed = {'tsserver', 'rust_analyzer'},
    handlers = {
        rust_analyzer = function()
            vim.lsp.config('rust_analyzer', {
                settings = {
                    ["rust-analyzer"] = {
                        imports = {
                            granularity = {
                                group = "module",
                            },
                            prefix = "self",
                        },
                        cargo = {
                            allFeatures = true,
                        },
                        procMacro = {
                            enable = true
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                    }
                }
            })
        end,
        groovyls = function()
            vim.lsp.config('groovyls', {
                filetypes = { "groovy" }
            })
        end,
    },
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true,
})

local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.rs", "*.ts", "*.js", "*.tf", "*.tfvars", "*.lua", "*.go", "*.gomod" },
    callback = function(ev)
        local buffer = ev.buf
        local ft = vim.filetype.match({ buf = tonumber(buffer) })
        local terraformls = require("lspconfig").terraformls

        if ft == nil then
            print("Filetype not detected for formatting...")
        elseif ft == "terraform" and terraformls == nil then
            print("terraformls not installed, hence fallback to neovim default formatting...")
        else
            vim.lsp.buf.format({ timeout_ms = 2000 })
        end
    end,

    group = format_sync_grp,
})

local blackf = require('kuldeep.non-lsp-formatter')
if blackf ~= nil then
    blackf.setup { name = "black", cmd_args = "-S" }
end

local log = require('consolelog').setup { name = "CustomLSPFormatter" }
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.py" },
    callback = function(ev)
        local bufnr_str = ev.buf
        if blackf ~= nil then
            blackf.format({ buf = tonumber(bufnr_str) })
        else
            log.error("Could not load blackf module")
        end
    end,
    group = format_sync_grp
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('override.lsp.keybindings', {}),

  callback = function(ev)

    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    on_attach(client, tonumber(ev.buf))

    --if client:supports_method('textDocument/implementation') then

    --  -- Create a keymap for vim.lsp.buf.implementation ...

    --end



    ---- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|

    --if client:supports_method('textDocument/completion') then

    --  -- Optional: trigger autocompletion on EVERY keypress. May be slow!

    --  -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end

    --  -- client.server_capabilities.completionProvider.triggerCharacters = chars



    --  vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})

    --end



    ---- Auto-format ("lint") on save.

    ---- Usually not needed if server supports "textDocument/willSaveWaitUntil".

    --if not client:supports_method('textDocument/willSaveWaitUntil')

    --    and client:supports_method('textDocument/formatting') then

    --  vim.api.nvim_create_autocmd('BufWritePre', {

    --    group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),

    --    buffer = ev.buf,

    --    callback = function()

    --      vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })

    --    end,

    --  })

    --end

  end,

})
