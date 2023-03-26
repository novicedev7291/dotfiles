print("This is nvim init file")
local vim = vim
-- Bootstrapping packer

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
	package_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
		install_path })
end

require('packer').startup(function(use)
	use 'navarasu/onedark.nvim' -- Theme inspired by Atom

	-- LSP config plugin
	use 'neovim/nvim-lspconfig'
	use 'hrsh7th/nvim-cmp' -- Autocomplete plugin
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	use 'L3MON4D3/LuaSnip' -- Snippets plugin

	-- Language Server installer
	use {
		'williamboman/nvim-lsp-installer',
		requires = 'neovim/nvim-lspconfig',
	}

	use 'nvim-treesitter/nvim-treesitter' -- Fast incremental parsing tree library for source code for any language
	use 'vim-scripts/auto-pairs-gentle' -- Auto generate pairs i.e. {, ", [ etc.

	use {
		'nvim-telescope/telescope.nvim',
		requires = 'nvim-lua/plenary.nvim'
	}

	-- This for the nice status line in vim, which comes at bottom
	use {
		'nvim-lualine/lualine.nvim',
		requires = {
			'kyazdani42/nvim-web-devicons',
			opt = true,
		}
	}
	if package_bootstrap then
		require('packer').sync()
	end
end)



vim.cmd [[
	augroup Packer
		autocmd!
		autocmd BufWritePost init.lua PackerCompile
	augroup end
]]

-- Map leader key to space
vim.g.mapleader = " "

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

-- Set the indentation to follow
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.autoindent = true

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
vim.cmd [[
	augroup YankHighlight
		autocmd!
		autocmd TextYankPost * silent! lua vim.highlight.on_yank()
	augroup end
]]



-- LSP config mappings
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }

-- Set nop for arrow keys
vim.api.nvim_set_keymap('n', '<up>', '<nop>', opts)
vim.api.nvim_set_keymap('n', '<down>', '<nop>', opts)
vim.api.nvim_set_keymap('i', '<up>', '<nop>', opts)
vim.api.nvim_set_keymap('i', '<down>', '<nop>', opts)
vim.api.nvim_set_keymap('i', '<left>', '<nop>', opts)
vim.api.nvim_set_keymap('i', '<right>', '<nop>', opts)

-- Set left/right to switch b/wn prev and next buffer
vim.api.nvim_set_keymap('n', '<left>', ':bp<CR>', opts)
vim.api.nvim_set_keymap('n', '<right>', ':bn<CR>', opts)

-- Map Ctrl+j, Ctrl + c to escape
vim.api.nvim_set_keymap('n', '<c-j>', '<Esc>', opts)
vim.api.nvim_set_keymap('v', '<c-j>', '<Esc>', opts)
vim.api.nvim_set_keymap('i', '<c-c>', '<Esc>', opts)
vim.api.nvim_set_keymap('v', '<c-c>', '<Esc>', opts)

vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Telescope key bindings for fuzzy file findings
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)

-- Clear searched hightlights on pressing escape
vim.api.nvim_set_keymap('n', '<leader><esc>', ':noh<return>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ge', '<cmd>lua vim.lsp.show_line_diagnostics()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl',
		'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end


local servers = { 'pyright', 'gopls', 'tsserver', 'html', 'emmet_ls', 'sumneko_lua', 'rust_analyzer', 'jedi_language_server' }

local lspconfig = require('lspconfig')
local lsp_installer = require('nvim-lsp-installer')

for _, server_name in pairs(servers) do
	local server_is_found, server = lsp_installer.get_server(server_name)

	if server_is_found and not server:is_installed() then
		print("Installing " .. server_name)
		server:install()
	end
end

local server_specific_opts = {
	html = function(opts)
		opts.filetypes = { "html" }
	end,
	emmet_ls = function(opts)
		opts.filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" }
	end,
	rust_analyzer = function(opts)
		opts.checkOnSave = { command = "clippy" }
	end,
	pyright = function(opts)
		opts.capabilities.completionProvider = false
		opts.capabilities.hoverProvider = false
	end,
	jedi_language_server = function(opts)
		opts.completionProvider = true
		opts.hoverProvider = true
	end,
}

-- Enable some LSP servers with the additional completion capabilites offerred by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local jedi_capabilities = {
	hoverProvider = true,
	completionProvider = true,
}

lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}


	if server_specific_opts[server.name] then
		server_specific_opts[server.name](opts)
	end

	server:setup(opts)
end)

-- luasnip setup
local luasnip = require('luasnip')

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup {
	completion = {
		autocomplete = false
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},

}

-- Auto add pairs
vim.g.AutoPairs = {
	['('] = ')',
	['['] = ']',
	['{'] = '}',
	["'"] = "'",
	['"'] = '"',
	['`'] = '`',
	['<'] = '>',
}

require('onedark').load()

require('nvim-treesitter.configs').setup {
	ensure_installed = { 'python', 'go', 'typescript', 'javascript', 'html' },
	highlight = {
		enable = true, -- false will disable the whole extension
		-- additional_vim_regex_highlighting = false
	}
}

require('telescope').setup {
	defaults = {
		file_ignore_patterns = { "node_modules", "dist", "coverage" }
	}
}

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	extensions = {}
}
