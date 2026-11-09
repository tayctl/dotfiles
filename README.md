# Nix based system configuration

## Installation

```bash
nix-shell git
git clone https://github.com/tayctl/dotfiles ~/dotfiles
cd ~/dotfiles
cp /etc/nixos/hardware-configuration.nix hosts/laptop/
git add .
sudo env NIX_CONFIG="experimental-features = nix-command flakes" 
sudo nixos-rebuild switch --flake .#laptop
```

## Eduroam

```bash
nix run 'github:mayniklas/eduroam-flake'#install-eduroam-dtu
```

## Work machines

Two hosts share the Hyprland desktop with the laptop but use `home/work.nix`
instead of `home/personal.nix`:

- `work-desktop` (Nvidia, see `modules/nvidia.nix`)
- `work-laptop`

```bash
cp /etc/nixos/hardware-configuration.nix hosts/work-desktop/   # or hosts/work-laptop/
git add .
sudo nixos-rebuild switch --flake .#work-desktop               # or .#work-laptop
```

Add work git remotes to `workRemotes` in `home/work.nix` to use the work
identity for those repos.

Yocto/BitBake tooling (official BitBake language server, kas, build host deps)
lives in an FHS dev shell rather than system-wide:

```bash
nix develop ~/dotfiles#yocto
```

Launch nvim from inside that shell so it picks up the BitBake LSP. The first
build fails on `npmDepsHash` in `pkgs/language-server-bitbake/default.nix`;
replace `lib.fakeHash` with the `got:` hash from the error.
