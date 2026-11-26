
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', '<leader>vws', function()
      vim.lsp.buf.workspace_symbol()
    end, opts)

    vim.keymap.set('n', '<leader>vd', function()
      vim.diagnostic.open_float()
    end, opts)

    vim.keymap.set('n', '<leader>vca', function()
      vim.lsp.buf.code_action()
    end, opts)

    vim.keymap.set('n', '<leader>vrr', function()
      vim.lsp.buf.references()
    end, opts)

    vim.keymap.set('n', '<leader>vrn', function()
      vim.lsp.buf.rename()
    end, opts)

    vim.keymap.set('i', '<C-h>', function()
      vim.lsp.buf.signature_help()
    end, opts)

    vim.keymap.set('n', '<leader>lf', function()
      require('conform').format({ bufnr = event.buf, lsp_fallback = true })
    end, opts)
  end,
})

-- LSP capabilities for nvim-cmp
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = true,
})

-- Auto format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format({
      bufnr = args.buf,
      lsp_fallback = true,
    })
  end,
})

-- Mason setup
require('mason').setup({})

require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',
    'pyright',
    'texlab',
    'fsautocomplete',
    'jdtls',
    'harper_ls',
  },

  handlers = {
    -- Default handler for servers
    function(server_name)
      require('lspconfig')[server_name].setup({
        capabilities = lsp_capabilities,
      })
    end,

    -- Harper grammar/spell checker
    harper_ls = function()
      require('lspconfig').harper_ls.setup({
        capabilities = lsp_capabilities,
        filetypes = { 'typst', 'markdown', 'text', 'gitcommit' },
        settings = {
          ['harper-ls'] = {
            dialect = 'British',
            userDictPath = vim.fn.stdpath('config') .. '/harper_dict.txt',
          },
        },
      })
    end,

    -- Lua language server
    lua_ls = function()
      require('lspconfig').lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          },
        },
      })
    end,

    -- F# language server
    fsautocomplete = function()
      require('lspconfig').fsautocomplete.setup({
        capabilities = lsp_capabilities,
        cmd = { 'fsautocomplete', '--background-service-enabled' },
        filetypes = { 'fsharp' },
        init_options = {
          AutomaticWorkspaceInit = true,
        },
      })
    end,

    -- Java language server
    jdtls = function()
      require('lspconfig').jdtls.setup({
        capabilities = lsp_capabilities,
        filetypes = { 'java' },
        root_dir = require('lspconfig.util').root_pattern(
          '.git',
          'mvnw',
          'gradlew',
          'pom.xml',
          'build.gradle',
          'build.gradle.kts'
        ),
      })
    end,
  },
})

-- nvim-cmp setup
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),

  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})
