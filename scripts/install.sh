#!/bin/bash

install_yay() {
    sudo pacman -S --noconfirm --needed base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
}

install_applications() {
    # Core (change to intel-ucode if there is an intel chip in the system)
    sudo pacman -S --noconfirm --needed amd-ucode
    # Wifi, bluetooth etc
    sudo pacman -S --noconfirm --needed bluez bluez-utils cups networkmanager \ 
                            ufw iptables nftables

    # CLI Tools
    sudo pacman -S --noconfirm --needed neovim fzf tree-sitter tree-sitter-cli \
                    ripgrep tmux btop fastfetch tree sudo-rs bc bat
    yay -S --noconfirm --needed tlrc-bin

    sudo pacman -S --noconfirm --needed powertop cpupower
    sudo pacman -S --noconfirm --needed texlive typst
    sudo pacman -S --noconfirm --needed stow

    # Utils
    sudo pacman -S --noconfirm --needed firefox nautilus udiskie thunderbird \
        poppler brightnessctl zathura usbutils unzip pipewire pipewire-pulse \
        iwd eog pandoc
    yay -S --noconfirm --needed zen-browser-bin

    # Dev
    sudo pacman -S --noconfirm --needed gcc nodejs cargo python

    # Hyprland
    sudo pacman -S --noconfirm --needed kitty wofi waybar wl-clipboard hyprlock \
        hypridle hyprpaper hyprpicker hyprland
    yay -S --noconfirm --needed xdg-desktop-portal-hyprland

    # AUR packages
    yay -S --noconfirm --needed hyprshot zotero vscodium-bin google-chrome \
    vesktop bitwarden bambustudio-bin paccache-hook

    # Cloud storage
    sudo pacman -S --needed --noconfirm libsecret gnome-keyring pika-backup pika-backup-monitor
    yay -S --needed --noconfirm filen-desktop
    curl -sL https://filen.io/cli.sh | bash

    # Misc
    sudo pacman -S --noconfirm --needed maven obs-studio signal-desktop krita \
    libsecret dotnet-sdk batsignal 
}

install_fonts() {

    sudo pacman -S --needed --noconfirm noto-fonts noto-fonts-cjk \
    noto-fonts-emoji noto-fonts-extra ttf-ibmplex-mono-nerd ttf-ibm-plex \ 
    adwaita-icon-theme

    fc-cache -f -v
}

setup_git() {
    git config --global user.name "tayctl"
    git config --global user.email "git@sebastiantaylor.com"
}

setup_dotfiles() {
    if command -v stow >/dev/null 2>&1; then
        mkdir -p "$HOME/.config"
        stow -d "$HOME/dotfiles" -t "$HOME" dots
        cp -r "$HOME/dotfiles/flags/" "$HOME/.config/"
    fi
}

setup_python() {
    python -m venv "$HOME/.globalenv"
    "$HOME/.globalenv/bin/pip" install -r "$HOME/dotfiles/scripts/python-pkgs.txt"
    "$HOME/.globalenv/bin/python" -m ipykernel install --user --name=globalenv 
     \ --display-name "Python (globalenv)"
}

setup_scripts() {
    mkdir -p "$HOME/.local/bin"

    chmod +x "$HOME/dotfiles/scripts/fcd.sh"
    ln -sf "$HOME/dotfiles/scripts/fcd.sh" "$HOME/.local/bin/fcd"

    chmod +x "$HOME/dotfiles/scripts/filen-automount.sh"
    ln -sf "$HOME/dotfiles/scripts/filen-automount.sh" \
        "$HOME/.local/bin/filen-automount"
}

system_services() {
    # Time & Date
    sudo timedatectl set-timezone Europe/Copenhagen
    sudo localectl set-locale LANG=en_GB.UTF-8

    # Enable services
    systemctl --user --enable --now batsignal
    sudo systemctl enable NetworkManager
    sudo systemctl enable bluetooth
    sudo systemctl enable cups
    sudo systemctl enable fstrim.timer
    sudo systemctl enable ufw.service
    sudo usermod -aG wheel,audio,video,input,storage "$USER"
    sudo systemctl start NetworkManager
    systemctl --user enable --now pipewire pipewire-pulse
    systemctl enable --user udiskie
}

networkmanager_config() {
    sudo tee /etc/NetworkManager/NetworkManager.conf <<EOF
    [main]
    dns=none
    plugins=keyfile
    [device]
    wifi.powersave=2
    ethernet.cloned-mac-address=random
    wifi.cloned-mac-address=random
    [connection]
    ipv6.method=auto
    # [device]
    # wifi.backend=iwd
    EOF
}

firewall() {
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow from 192.168.0.0/24

    sudo ufw allow ssh
    sudo ufw limit ssh

    sudo ufw enable

    sudo systemctl restart NetworkManager
}

setup_zsh() {
    sudo pacman -S --noconfirm --needed zsh
    grep -qx '/sbin/zsh' /etc/shells || echo '/sbin/zsh' | sudo tee -a /etc/shells
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Run 'chsh -s /sbin/zsh' to set zsh as your default shell"
}

main() {
    sudo pacman -Syu
    sudo pacman -S --noconfirm --needed git

    install_yay
    hash -r
    install_applications
    install_fonts
    setup_git
    setup_dotfiles
    setup_python
    setup_scripts
    setup_zsh
    system_services
    networkmanager_config
    firewall
    setup_ssh

    echo "To optimise power run 'sudo powertop --calibrate"
}

setup_ssh() {
    ssh-keygen -t ed25519 -C "me@sebastian-taylor.com"
    echo "Add your public key to GitHub: cat ~/.ssh/id_ed25519.pub | wl-copy"
}

main
