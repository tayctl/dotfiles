# Yocto tooling for ql-yocto. Builds themselves run in the team's container
# through `yb` (scripts/yocto/yb.sh), since BitBake wants a normal FHS host.
#
# Symlinked into the project rather than committed there:
#   ln -s ~/dotfiles/devenv/yocto/devenv.{nix,yaml} ~/Projects/ql-yocto/
#   printf '%s\n' devenv.nix devenv.yaml devenv.lock .devenv '.devenv*' >> ~/Projects/ql-yocto/.git/info/exclude
{ pkgs, inputs, ... }:
{
  packages = [
    pkgs.kas
    pkgs.minicom
    inputs.dotfiles.packages.${pkgs.stdenv.hostPlatform.system}.language-server-bitbake
  ];
}
