# Yocto tooling for ql-yocto. Builds themselves run in the team's container
# through `yb` (scripts/yocto/yb.sh), since BitBake wants a normal FHS host.
#
# Stays here rather than in the project; only .envrc gets symlinked in to
# autoload it (devenv's --from points back at this directory):
#   ln -s ~/dotfiles/devenv/yocto/.envrc ~/Projects/ql-yocto/.envrc
#   printf '%s\n' .envrc .direnv devenv.lock .devenv '.devenv*' >> ~/Projects/ql-yocto/.git/info/exclude
#   direnv allow ~/Projects/ql-yocto
{ pkgs, inputs, ... }:
{
  devenv.warnOnNewVersion = false; # quiet autoload: see .envrc

  packages = [
    pkgs.kas
    pkgs.minicom
    inputs.dotfiles.packages.${pkgs.stdenv.hostPlatform.system}.language-server-bitbake
    pkgs.android-tools
    pkgs.git-lfs
  ];
}
