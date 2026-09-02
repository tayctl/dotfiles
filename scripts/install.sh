#!/bin/bash

set -Eeuo pipefail

readonly REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
readonly LOG_FILE="$STATE_DIR/install.log"
DRY_RUN=false

usage() {
    cat <<EOF
Usage: ${0##*/} [--dry-run]

Options:
  --dry-run  Show planned changes without modifying the system
  -h, --help Show this help
EOF
}

parse_args() {
    while (($#)); do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                ;;
            -h | --help)
                usage
                exit 0
                ;;
            *)
                die "Unknown argument: $1"
                ;;
        esac
        shift
    done
}

log() {
    local message
    printf -v message '\n[%(%Y-%m-%d %H:%M:%S)T] %s\n' -1 "$*"
    printf '%s' "$message"

    if [[ "$DRY_RUN" == false && -d "$STATE_DIR" ]]; then
        printf '%s' "$message" >>"$LOG_FILE"
    fi
}

die() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

on_error() {
    local exit_code=$?
    local message
    printf -v message 'ERROR: command failed at %s:%s (exit %s): %s\n' \
        "${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}" \
        "${BASH_LINENO[0]:-unknown}" "$exit_code" "$BASH_COMMAND" >&2
    printf '%s' "$message" >&2

    if [[ "$DRY_RUN" == false && -d "$STATE_DIR" ]]; then
        printf '%s' "$message" >>"$LOG_FILE"
    fi

    exit "$exit_code"
}

trap on_error ERR

print_command() {
    printf '  command:'
    printf ' %q' "$@"
    printf '\n'
}

clean_build_env() {
    env \
        -u CONDA_PREFIX \
        -u PYTHONHOME \
        -u PYTHONPATH \
        -u VIRTUAL_ENV \
        PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin \
        "$@"
}

as_root() {
    if (( EUID == 0 )); then
        "$@"
    else
        sudo "$@"
    fi
}

run_step() {
    local description="$1"
    shift
    local started=$SECONDS

    log "$description"

    if [[ "$DRY_RUN" == true ]]; then
        describe_action "$@"
        return
    fi

    "$@"
    log "Completed in $((SECONDS - started))s"
}

read_package_file() {
    local package_file="$1"
    sed -E 's/[[:space:]]*#.*$//' "$package_file" | awk 'NF'
}

read_missing_repo_packages() {
    local package

    while IFS= read -r package; do
        if pacman -T "$package" >/dev/null 2>&1; then
            continue
        fi

        printf '%s\n' "$package"
    done < <(read_package_file "$REPO_ROOT/scripts/packages/official.txt")
}

read_missing_aur_packages() {
    local package

    while IFS= read -r package; do
        if [[ "$package" == bibata-cursor-theme-bin &&
            -f /usr/share/icons/Bibata-Modern-Ice/index.theme ]]; then
            continue
        fi

        if pacman -T "$package" >/dev/null 2>&1; then
            continue
        fi

        printf '%s\n' "$package"
    done < <(read_package_file "$REPO_ROOT/scripts/packages/aur.txt")
}

microcode_package() {
    local vendor
    vendor="$(
        awk -F: '/vendor_id/ {
            gsub(/[[:space:]]/, "", $2)
            print $2
            exit
        }' /proc/cpuinfo
    )"

    case "$vendor" in
        AuthenticAMD)
            printf '%s\n' amd-ucode
            ;;
        GenuineIntel)
            printf '%s\n' intel-ucode
            ;;
    esac
}

describe_action() {
    local action="$1"
    shift
    local -a packages
    local microcode

    case "$action" in
        as_root)
            print_command sudo "$@"
            ;;
        install_repo_packages)
            mapfile -t packages < <(read_missing_repo_packages)
            if ((${#packages[@]})); then
                print_command sudo pacman -S --needed --noconfirm \
                    "${packages[@]}"
            else
                printf '  action: skip; all capabilities are installed\n'
            fi
            printf '  action: preserve installed packages that provide requested capabilities\n'
            ;;
        install_microcode)
            microcode="$(microcode_package)"
            if [[ -n "$microcode" ]]; then
                print_command sudo pacman -S --needed --noconfirm "$microcode"
            else
                printf '  action: skip microcode; CPU vendor is unknown\n'
            fi
            ;;
        install_yay)
            if command -v yay >/dev/null 2>&1; then
                printf '  action: skip; yay is already installed\n'
            else
                printf '  action: build and install yay in a temporary directory\n'
            fi
            ;;
        install_aur_packages)
            mapfile -t packages < <(read_missing_aur_packages)
            if ((${#packages[@]})); then
                print_command env -u CONDA_PREFIX -u PYTHONHOME -u PYTHONPATH \
                    -u VIRTUAL_ENV \
                    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin \
                    yay -S --needed --noconfirm "${packages[@]}"
            else
                printf '  action: skip; all capabilities are installed\n'
            fi
            ;;
        install_filen_cli)
            printf '  action: install the Filen CLI if it is missing\n'
            ;;
        install_fonts)
            print_command fc-cache -f
            ;;
        setup_git)
            printf '  action: set missing global Git name and email values\n'
            ;;
        setup_dotfiles)
            printf '  action: restow dots/ into %s and install Electron flags\n' \
                "$HOME"
            ;;
        setup_python)
            printf '  action: create/update ~/.globalenv and its Jupyter kernel\n'
            ;;
        setup_rust)
            printf '  action: install and select the stable Rust toolchain\n'
            ;;
        setup_scripts)
            printf '  action: link repository scripts into ~/.local/bin\n'
            ;;
        setup_zsh)
            printf '  action: install Oh My Zsh and set Zsh as the login shell\n'
            ;;
        setup_locale)
            printf '  action: set Europe/Copenhagen and en_GB.UTF-8\n'
            ;;
        setup_services)
            printf '  action: enable system and user services and update groups\n'
            ;;
        setup_networkmanager)
            printf '  action: install /etc/NetworkManager/conf.d/20-dotfiles.conf\n'
            ;;
        setup_firewall)
            printf '  action: configure and enable the UFW firewall\n'
            ;;
        setup_ssh)
            printf '  action: create a missing SSH key and install keepalives\n'
            ;;
        *)
            print_command "$action" "$@"
            ;;
    esac
}

install_repo_packages() {
    local -a packages
    mapfile -t packages < <(read_missing_repo_packages)

    if ((${#packages[@]} == 0)); then
        log "All repository package capabilities are already installed"
        return
    fi

    as_root pacman -S --needed --noconfirm "${packages[@]}"
}

install_microcode() {
    local microcode
    microcode="$(microcode_package)"

    if [[ -n "$microcode" ]]; then
        as_root pacman -S --needed --noconfirm "$microcode"
    else
        log "Unknown CPU vendor; skipping microcode package"
    fi
}

install_yay() {
    if command -v yay >/dev/null 2>&1; then
        return
    fi

    local build_dir
    build_dir="$(mktemp -d)"
    git clone --depth 1 https://aur.archlinux.org/yay.git "$build_dir/yay"
    (
        cd "$build_dir/yay"
        clean_build_env makepkg -si --noconfirm
    )
    rm -rf -- "$build_dir"
}

install_aur_packages() {
    local available_kib
    local -a packages
    local package
    local -r minimum_kib=$((5 * 1024 * 1024))

    mapfile -t packages < <(read_missing_aur_packages)
    if ((${#packages[@]} == 0)); then
        log "All AUR package capabilities are already installed"
        return
    fi

    available_kib="$(df --output=avail / | awk 'NR == 2 {print $1}')"
    if (( available_kib < minimum_kib )); then
        die "Less than 5 GiB is free on /. Clean the package cache with:
  sudo paccache -rk1
  sudo paccache -ruk0"
    fi

    for package in "${packages[@]}"; do
        log "Installing AUR package: $package"
        clean_build_env yay -S --needed --noconfirm "$package"
    done
}

install_filen_cli() {
    if [[ -x "$HOME/.filen-cli/bin/filen" ]]; then
        return
    fi

    local installer
    installer="$(mktemp)"
    curl --fail --location --proto '=https' --tlsv1.2 \
        https://filen.io/cli.sh -o "$installer"
    bash "$installer"
    rm -f -- "$installer"
}

install_fonts() {
    fc-cache -f
}

setup_git() {
    if [[ -z "$(git config --global --get user.name || true)" ]]; then
        git config --global user.name "tayctl"
    fi

    if [[ -z "$(git config --global --get user.email || true)" ]]; then
        git config --global user.email "git@sebastiantaylor.com"
    fi
}

setup_dotfiles() {
    mkdir -p "$HOME/.config"
    stow --restow --dir "$REPO_ROOT" --target "$HOME" dots
    install -m 0644 "$REPO_ROOT/flags/electron-flags.conf" \
        "$HOME/.config/electron-flags.conf"
    install -m 0644 "$REPO_ROOT/flags/code-flags.conf" \
        "$HOME/.config/code-flags.conf"
}

setup_python() {
    if [[ ! -x "$HOME/.globalenv/bin/python" ]]; then
        python -m venv "$HOME/.globalenv"
    fi

    "$HOME/.globalenv/bin/python" -m pip install --upgrade pip
    "$HOME/.globalenv/bin/python" -m pip install \
        -r "$REPO_ROOT/scripts/python-pkgs.txt"

    if ! "$HOME/.globalenv/bin/jupyter" kernelspec list 2>/dev/null |
        grep -q 'globalenv'; then
        "$HOME/.globalenv/bin/python" -m ipykernel install --user \
            --name globalenv --display-name "Python (globalenv)"
    fi
}

setup_rust() {
    if ! rustup toolchain list | grep -q '^stable'; then
        rustup toolchain install stable
    fi

    rustup default stable
}

setup_scripts() {
    local script
    mkdir -p "$HOME/.local/bin"

    for script in fcd filen-automount power-menu temp-clean; do
        chmod +x "$REPO_ROOT/scripts/$script.sh"
        ln -sfn "$REPO_ROOT/scripts/$script.sh" "$HOME/.local/bin/$script"
    done
}

setup_zsh() {
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ -e "$HOME/.oh-my-zsh" && ! -d "$HOME/.oh-my-zsh/.git" ]]; then
        die "$HOME/.oh-my-zsh exists but is not an Oh My Zsh Git checkout"
    fi

    if [[ ! -d "$HOME/.oh-my-zsh/.git" ]]; then
        git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git \
            "$HOME/.oh-my-zsh"
    fi

    if ! grep -qxF "$zsh_path" /etc/shells; then
        printf '%s\n' "$zsh_path" | as_root tee -a /etc/shells >/dev/null
    fi

    if [[ "${SHELL:-}" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
    fi
}

setup_locale() {
    as_root timedatectl set-timezone Europe/Copenhagen

    if grep -q '^#en_GB.UTF-8 UTF-8' /etc/locale.gen; then
        as_root sed -i 's/^#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
        as_root locale-gen
    fi

    as_root localectl set-locale LANG=en_GB.UTF-8
}

setup_services() {
    as_root systemctl enable --now \
        NetworkManager.service \
        bluetooth.service \
        cups.socket \
        avahi-daemon.service \
        fstrim.timer \
        power-profiles-daemon.service

    as_root usermod -aG wheel,audio,video,input,storage "$USER"

    systemctl --user daemon-reload
    systemctl --user enable --now batsignal.service temp-clean.timer
}

setup_networkmanager() {
    local config
    config="$(mktemp)"

    cat >"$config" <<'EOF'
[main]
plugins=keyfile

[device]
wifi.backend=iwd
wifi.powersave=2
ethernet.cloned-mac-address=random
wifi.cloned-mac-address=random
EOF

    as_root install -Dm0644 "$config" \
        /etc/NetworkManager/conf.d/20-dotfiles.conf
    rm -f -- "$config"
    as_root systemctl restart NetworkManager.service
}

setup_firewall() {
    as_root ufw default deny incoming
    as_root ufw default allow outgoing

    if [[ "${DOTFILES_ALLOW_SSH:-0}" == 1 ]]; then
        as_root ufw limit OpenSSH
    fi

    if [[ -n "${DOTFILES_LAN_CIDR:-}" ]]; then
        as_root ufw allow from "$DOTFILES_LAN_CIDR"
    fi

    as_root ufw --force enable
    as_root systemctl enable --now ufw.service
}

setup_ssh() {
    local config_tmp

    mkdir -p "$HOME/.ssh"
    mkdir -p "$HOME/.ssh/config.d"
    chmod 700 "$HOME/.ssh"
    chmod 700 "$HOME/.ssh/config.d"

    if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
        ssh-keygen -t ed25519 -C "me@sebastian-taylor.com" \
            -f "$HOME/.ssh/id_ed25519"
        log "Add the SSH key to GitHub with: wl-copy < ~/.ssh/id_ed25519.pub"
    fi

    cat >"$HOME/.ssh/config.d/20-dotfiles-keepalive.conf" <<'EOF'
Host *
    ServerAliveInterval 15
    ServerAliveCountMax 3
    ConnectTimeout 10
EOF
    chmod 600 "$HOME/.ssh/config.d/20-dotfiles-keepalive.conf"

    if [[ ! -f "$HOME/.ssh/config" ]]; then
        printf 'Include ~/.ssh/config.d/*\n' >"$HOME/.ssh/config"
    elif ! grep -qxF 'Include ~/.ssh/config.d/*' "$HOME/.ssh/config"; then
        config_tmp="$(mktemp)"
        {
            printf 'Include ~/.ssh/config.d/*\n\n'
            cat "$HOME/.ssh/config"
        } >"$config_tmp"
        install -m 0600 "$config_tmp" "$HOME/.ssh/config"
        rm -f -- "$config_tmp"
    fi

    chmod 600 "$HOME/.ssh/config"
}

preflight() {
    [[ -f /etc/arch-release ]] || die "This installer supports Arch Linux only"
    [[ -f "$REPO_ROOT/scripts/packages/official.txt" ]] ||
        die "Run the installer from a complete dotfiles checkout"
    command -v sudo >/dev/null 2>&1 || die "sudo is required"
}

main() {
    parse_args "$@"

    if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$STATE_DIR"
    fi

    preflight
    run_step "Updating the system" as_root pacman -Syu --noconfirm
    run_step "Installing bootstrap packages" as_root pacman -S \
        --needed --noconfirm base-devel git
    run_step "Installing repository packages" install_repo_packages
    run_step "Installing CPU microcode" install_microcode
    run_step "Installing yay" install_yay
    run_step "Installing AUR packages" install_aur_packages
    run_step "Installing the Filen CLI" install_filen_cli
    run_step "Refreshing fonts" install_fonts
    run_step "Configuring Git" setup_git
    run_step "Stowing dotfiles" setup_dotfiles
    run_step "Configuring Python" setup_python
    run_step "Configuring Rust" setup_rust
    run_step "Linking user scripts" setup_scripts
    run_step "Configuring Zsh" setup_zsh
    run_step "Configuring locale and timezone" setup_locale
    run_step "Configuring system services" setup_services
    run_step "Configuring NetworkManager" setup_networkmanager
    run_step "Configuring the firewall" setup_firewall
    run_step "Configuring SSH" setup_ssh

    if [[ "$DRY_RUN" == true ]]; then
        log "Dry run complete. No changes were made."
    else
        log "Installation complete. Reboot before starting Hyprland."
        log "Installer log: $LOG_FILE"
    fi
}

main "$@"
