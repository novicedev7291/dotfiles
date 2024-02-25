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
        version = "0.1.0",
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
        lazy = false
    },
    -- Treesitter plugin to provide parsing capability for file type & colors accordingly
    {
        "nvim-treesitter/nvim-treesitter"
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
    "rcarriga/nvim-dap-ui",
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
    }
}

require("lazy").setup(plugins)
