return {
    -- AI
    -- { 'github/copilot.vim' },

    -- Colorschemes
    { 'ellisonleao/gruvbox.nvim' },
    { 'shaunsingh/nord.nvim' },
    { 'e-ink-colorscheme/e-ink.nvim' },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        lazy = false,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
    },

    -- Navigation
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- LSP
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    -- Completion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'L3MON4D3/LuaSnip' },
    { 'saadparwaiz1/cmp_luasnip' },

    -- Git
    {
        'NeogitOrg/Neogit',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'sindrets/diffview.nvim',
        },
    },
    {
      "tpope/vim-dadbod",
      dependencies = {
        "kristijanhusak/vim-dadbod-ui",
        "kristijanhusak/vim-dadbod-completion",
      },
      cmd = { "DB", "DBUI", "DBUIToggle" },
    },

    -- Utilities
    { 'lervag/vimtex' },
    { 'stevearc/conform.nvim' },
    { 'NvChad/nvim-colorizer.lua' },
    { 'Aasim-A/scrollEOF.nvim' },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup {}
        end,
    },
}
