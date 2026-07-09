local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- Telescope plugin for fuzzy finding and other awesome search optionremaps
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.4",
        -- or                            , branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    },
    {
        "rmehri01/onenord.nvim",
        lazy = true
    },
    -- Treesitter plugin to provide parsing capability for file type & colors accordingly
    {
        "neovim-treesitter/nvim-treesitter", 
        dependencies = { 'neovim-treesitter/treesitter-parser-registry' },
        lazy = false,
        build = ':TSUpdate'
    },
    "nvim-treesitter/nvim-treesitter-context",
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            -- LSP Support
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Autocompletion
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",

            -- Snippets
            "L3MON4D3/LuaSnip",
            --"rafamadriz/friendly-snippets",
        }
    },
    "tpope/vim-fugitive",
    "vim-scripts/auto-pairs-gentle",

    --Debugging support
    "mfussenegger/nvim-dap",
    "theHamsta/nvim-dap-virtual-text",
    {    
        "rcarriga/nvim-dap-ui", 
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
    },
    "mfussenegger/nvim-dap-python",

    --personal logging plugin
    "novicedev7291/consolelog.nvim",
    {
        "github/copilot.vim",
        enabled = function()
            if not vim.env.USE_COPILOT then
                return false
            end
            return true
        end
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        build = "make tiktoken",
        opts = {
            model = 'gpt-4.1',           -- AI model to use
            temperature = 0.4,           -- Lower = focused, higher = creative
            window = {
                layout = 'vertical',       -- 'vertical', 'horizontal', 'float'
                width = 0.3,              -- 50% of screen width
            },
            auto_insert_mode = true,     -- Enter insert mode when opening
        },
    },
}

require("lazy").setup(plugins)
