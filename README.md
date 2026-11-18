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

## Work laptop

`work-laptop` (HP ZBook Studio 16 G11, Intel + Nvidia PRIME offload) shares
the Hyprland desktop with the laptop but uses `home/work.nix` instead of
`home/personal.nix`: work git identity by default (`tayctl` for
github.com/tayctl repos), work SSH config, and kanshi turning the built-in
screen off while docked.

Before wiping the old install, copy to a USB drive: `~/.ssh` (keys are not in
this repo), `~/Projects` (anything unpushed) and optionally `~/.yocto-cache`.

```bash
nix-shell -p git
git clone https://github.com/tayctl/dotfiles ~/dotfiles
cd ~/dotfiles && git checkout nix
cp /etc/nixos/hardware-configuration.nix hosts/work-laptop/
git add hosts/work-laptop/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#work-laptop

# after the reboot, restore the SSH keys from the USB drive
cp /run/media/$USER/<usb>/ssh/id_* ~/.ssh/
chmod 600 ~/.ssh/id_ed25519 ~/.ssh/id_rsa
```

### Yocto

Builds run in the team's container with `yb` (`scripts/yocto/yb.sh`, needs
podman, which `modules/work.nix` enables). Tooling (kas, the official
BitBake language server, minicom) comes from the devenv in `devenv/yocto`,
symlinked into the project so the team repo stays untouched:

```bash
cd ~/Projects/ql-yocto
ln -s ~/dotfiles/devenv/yocto/devenv.{nix,yaml} .
printf '%s\n' devenv.nix devenv.yaml devenv.lock .devenv '.devenv*' >> .git/info/exclude
devenv shell
```

Launch nvim from inside the devenv shell so it picks up the BitBake LSP.
