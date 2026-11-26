return {
    -- AI
    -- { 'github/copilot.vim' },

    -- Colorschemes
    { 'ellisonleao/gruvbox.nvim' },
    { 'shaunsingh/nord.nvim' },
    { 'e-ink-colorscheme/e-ink.nvim' },
    { 'kepano/flexoki-neovim' },

    -- lean (used for bachelor project)
    {
      'Julian/lean.nvim',
      event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
      init = function()
        vim.g.lean_config = {
          mappings = true,
          goal_markers = {
            unsolved = ' \u{f0ad} ',     --  wrench
            accomplished = '\u{f00c}',   --  check
          },
          progress_bars = {
            character = '\u{2503}',      -- ┃ heavy vertical bar
          },
          infoview = {
            indicators = 'auto',
            on_processing = function(previous)
              return previous or '\u{f110} Processing file...' --  spinner
            end,
            messages = {
              goals = {
                accomplished = '\u{f00c} Goals accomplished',   --  check
                none = '\u{f05e} No goals.',                    --  ban
                some = function(n)
                  if n == 1 then
                    return nil
                  end
                  return ('\u{f0ae} %d goals'):format(n)        --  tasks
                end,
              },
            },
            severity_markers = {
              '\u{f057} error:\n',      --  times-circle
              '\u{f071} warning:\n',    --  warning
              '\u{f05a} information:\n',--  info-circle
              '\u{f0eb} hint:\n',       --  lightbulb
            },
         },
       }
      end,
    },

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


    -- Utilities
    { 'lervag/vimtex' },
    { 'stevearc/conform.nvim' },
    { 'NvChad/nvim-colorizer.lua' },
    { 'Aasim-A/scrollEOF.nvim' },
    {
        'kdheepak/lazygit.nvim',
        cmd = { 'LazyGit', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup {}
        end,
    },
}
