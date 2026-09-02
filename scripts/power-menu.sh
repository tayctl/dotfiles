#!/bin/bash

set -euo pipefail

choice="$(
    printf '%s\n' Lock Logout Suspend Reboot Shutdown |
        wofi --dmenu --prompt 'Power'
)"

case "$choice" in
    Lock)
        loginctl lock-session
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    Suspend)
        systemctl suspend
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
