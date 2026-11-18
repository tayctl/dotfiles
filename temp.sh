#!/usr/bin/env bash
# Run this from your dotfiles directory

# Create new structure
mkdir -p zsh tmux/{.config,} nvim/.config kitty/.config hypr/.config btop/.config waybar/.config wofi/.config

# Move files
mv .config/.zshrc zsh/
mv .config/tmux.conf tmux/.tmux.conf
mv .config/nvim nvim/.config/
mv .config/kitty kitty/.config/
mv .config/hypr hypr/.config/
mv .config/btop btop/.config/
mv .config/waybar waybar/.config/
mv .config/wofi wofi/.config/

# Remove old .config directory if empty
rmdir .config 2>/dev/null || echo ".config directory not empty, check manually"
