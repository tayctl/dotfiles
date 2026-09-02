#!/bin/bash
# filen-automount.sh - Mount Filen cloud storage via FUSE
#
# Waits for an internet connection and mounts the Filen drive. Retries up to
# three times at two-minute intervals. Designed for a systemd user service.
#
# Supports notify-send (GNOME/KDE), dunstify (dunst), and kdialog as
# notification backends.
#
# Copyright 2026, Sebastian F. Taylor
# May be used under the terms of the MIT License.

filen="$HOME/.filen-cli/bin/filen"
mountpoint="$HOME/Cloud"
max_attempts=3

notify() {
    local urgency="$1"
    local title="$2"
    local body="$3"

    if command -v notify-send >/dev/null 2>&1; then
        # GNOME, KDE, most desktop environments
        notify-send -u "$urgency" "$title" "$body"
    elif command -v dunstify >/dev/null 2>&1; then
        # Dunst
        dunstify -u "$urgency" "$title" "$body"
    elif command -v kdialog >/dev/null 2>&1; then
        # KDE without libnotify
        kdialog --passivepopup "$title: $body" 10
    else
        echo "[$urgency] $title - $body" >&2
    fi
}

mount_drive() {
    local attempt=${1:-1}
    local output
    local status

    if mountpoint -q "$mountpoint"; then
        echo "Already mounted."
        return 0
    fi

    echo "Not mounted, attempting to mount..."
    mkdir -p "$mountpoint"

    # Capture both stdout and stderr
    output=$("$filen" --skip-update mount "$mountpoint" 2>&1)
    status=$?

    # Give FUSE a moment to finish mounting
    sleep 2

    if mountpoint -q "$mountpoint"; then
        echo "Mounted successfully."
        return 0
    fi

    # Keep notifications reasonably short
    output=$(printf '%s\n' "$output" | tail -n 10)

    notify critical "Filen Mount Failed" \
        "Could not mount cloud storage (attempt $attempt/$max_attempts)

Exit code: $status

${output:-No error output.}"

    return 1
}

try_connect() {
    local attempt

    for ((attempt = 1; attempt <= max_attempts; attempt++)); do
        if command -v nm-online >/dev/null 2>&1 &&
            ! nm-online --quiet --timeout=30; then
            echo "Attempt $attempt/$max_attempts: Network is not ready."
        elif mount_drive "$attempt"; then
            notify normal "Filen Drive Mounted" \
                "Your Filen drive has been mounted at: $mountpoint"
            return 0
        fi

        if (( attempt < max_attempts )); then
            echo "Retrying in 2 minutes..."
            sleep 120
        fi
    done

    notify critical "Filen Mount Failed" \
        "Cloud storage could not be mounted after $max_attempts attempts."
    return 1
}

main() {
    if [[ ! -x "$filen" ]]; then
        notify critical "Filen CLI Not Installed" \
            "Please place the Filen CLI executable at:

$filen"
        return 1
    fi

    try_connect
}

main
