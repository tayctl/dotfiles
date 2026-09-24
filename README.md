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
