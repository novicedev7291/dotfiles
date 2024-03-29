-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope plugin for fuzzy finding and other awesome search optionremaps
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { "nvim-telescope/telescope-live-grep-args.nvim" },
        },
        config = function()
            require('telescope').load_extension('live_grep_args')
        end
    }

    -- Rose pine theme for color
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        --config = function()
        --    vim.cmd.colorscheme('rose-pine')
        --end
    })
    use 'rmehri01/onenord.nvim'

    -- Treesitter plugin to provide parsing capability for file type & colors accordingly
    use('nvim-treesitter/nvim-treesitter', { tag = 'v0.8.5', lock = true })
    use 'nvim-treesitter/nvim-treesitter-context'
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use 'tpope/vim-fugitive'
    use 'vim-scripts/auto-pairs-gentle'

    --Debugging support
    use 'mfussenegger/nvim-dap'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'rcarriga/nvim-dap-ui'
    use 'mfussenegger/nvim-dap-python'

    --Personal logging plugin
    use {
        'novicedev7291/consolelog.nvim',
    }
end)
