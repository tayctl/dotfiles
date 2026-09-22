#!/usr/bin/env bash
set -e

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/dots/.config/home-manager"
HM="$HOME/.config/home-manager"

# get nix if it's not here yet
if ! command -v nix &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# make sure flakes aren't behind a feature flag
mkdir -p ~/.config/nix
grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null || \
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# link the config in if it's not already there
if [ ! -e "$HM" ]; then
    ln -s "$DOTS" "$HM"
elif [ ! -L "$HM" ]; then
    echo "$HM already exists and isn't a symlink, move it out of the way first"
    exit 1
fi

home-manager switch --flake "$HM#taylor" || nix run home-manager/master -- switch --flake "$HM#taylor"
