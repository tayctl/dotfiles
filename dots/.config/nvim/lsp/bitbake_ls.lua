-- Official Yocto BitBake language server (from the yocto devenv, devenv/yocto)
return {
  cmd = { 'language-server-bitbake', '--stdio' },
  filetypes = { 'bitbake' },
  root_markers = { 'conf/bblayers.conf', '.git' },
}
