-- Official Yocto BitBake language server (provided by `nix develop ~/dotfiles#yocto`)
if vim.fn.executable('language-server-bitbake') == 1 then
  vim.lsp.config('bitbake_ls', {
    cmd = { 'language-server-bitbake', '--stdio' },
    filetypes = { 'bitbake' },
    root_markers = { 'conf/bblayers.conf', '.git' },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  })
  vim.lsp.enable('bitbake_ls')
end
