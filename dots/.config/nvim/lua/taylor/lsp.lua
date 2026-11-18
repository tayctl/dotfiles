
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
      lsp_format = 'fallback', -- no conform formatter on PATH: let the LSP format
    })
  end,
})

-- Language servers come from nix, mostly from project devenvs (start nvim
-- from inside `devenv shell`), never from Mason. Every server that
-- nvim-lspconfig or lsp/ in this config knows about is enabled when its
-- executable is on PATH; the settings below only adjust some of them.
vim.lsp.config('*', { capabilities = lsp_capabilities })

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = { vim.env.VIMRUNTIME } },
    },
  },
})

vim.lsp.config('fsautocomplete', {
  cmd = { 'fsautocomplete', '--background-service-enabled' },
  filetypes = { 'fsharp' },
  init_options = { AutomaticWorkspaceInit = true },
})

vim.lsp.config('jdtls', {
  filetypes = { 'java' },
  root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts' },
})

-- Configs launched through a general-purpose interpreter are skipped: having
-- node or java installed says nothing about the server being installed
local interpreters = {
  node = true, npx = true, bun = true, java = true,
  python = true, python3 = true, perl = true, ruby = true, R = true,
  julia = true, dotnet = true, sh = true, bash = true,
}

local seen = {}
for _, file in ipairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local name = vim.fn.fnamemodify(file, ':t:r')
  if not seen[name] then
    seen[name] = true
    local ok, config = pcall(function() return vim.lsp.config[name] end)
    local cmd = ok and config and config.cmd
    if type(cmd) == 'table' and cmd[1] and not interpreters[cmd[1]]
        and vim.fn.executable(cmd[1]) == 1 then
      vim.lsp.enable(name)
    end
  end
end

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
