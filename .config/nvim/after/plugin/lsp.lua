local lsp = require('lsp-zero')

lsp.preset('recommended')

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['C-p'] = cmp.mapping.select_prev_item(cmp_select),
    ['C-n'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})
local cmp_completion = {
    autocomplete = false
    --    autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },
}

lsp.set_preferences({
    sign_icons = {}
})

cmp.setup({
    completion = cmp_completion,
    mapping = cmp_mappings
})

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

lsp.on_attach(on_attach)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  -- ensure_installed = {'tsserver', 'rust_analyzer'},
  handlers = {
    lsp.default_setup,
    rust_analyzer = function()
        require("lspconfig").rust_analyzer.setup({
            on_attach = on_attach,
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
    terraformls = function()
        local terraformls = require("lspconfig").terraformls
        if terraformls ~= nil then
            terraformls.setup {}
        end
    end,
    groovyls = function()
        local groovyls = require("lspconfig").groovyls
        if groovyls ~= nil then
            groovyls.setup {
                on_attach = on_attach,
                filetypes = { "groovy" }
            }
        end
    end,
    gopls = function()
        local gopls = require("lspconfig").gopls
        if gopls ~= nil then
            gopls.setup {
                on_attach = on_attach
            }
        end
    end,
    tsserver = function()
        local tsserver = require("lspconfig").tsserver
        if tsserver ~= nil then
            tsserver.setup {
                on_attach = on_attach
            }
        end
    end,
    clangd = function()
        local clangd = require("lspconfig").clangd
        if clangd ~= nil then
            clangd.setup {
                on_attach = on_attach
            }
        end
    end,
},
})


lsp.setup()

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
