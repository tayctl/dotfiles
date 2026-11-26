#!/bin/bash
# pclone.sh - Clone a git repository into ~/Projects and open a tmux session in it
#
# Usage: pclone <url> [directory-name]
#
# The directory name defaults to the repository name. If the project already
# exists it is not cloned again, the session is just opened. The session runs
# nvim, like fcd does. Set PROJECTS_DIR to clone somewhere other than ~/Projects.
#
# Copyright 2026, Sebastian F. Taylor
# May be used under the terms of the MIT License.

set -eu

projects_dir="${PROJECTS_DIR:-$HOME/Projects}"

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "usage: pclone <url> [directory-name]" >&2
    exit 1
fi

for cmd in git tmux nvim; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "$cmd not installed" >&2; exit 1; }
done

url="$1"
if [ $# -eq 2 ]; then
    name="$2"
else
    # https://host/user/repo.git, git@host:user/repo.git, repo/ -> repo
    name=$(basename "${url%/}")
    name="${name%.git}"
    name="${name##*:}"
fi
[ -n "$name" ] || { echo "could not work out a directory name, pass one" >&2; exit 1; }

dir="$projects_dir/$name"
mkdir -p "$projects_dir"

if [ -e "$dir" ]; then
    echo "$dir already exists, skipping clone"
else
    git clone "$url" "$dir"
fi

# tmux session names may not contain '.' or ':'
session=$(echo "$name" | tr '.:' '__')

if ! tmux has-session -t "=$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$dir"
    tmux send-keys -t "=$session:" "nvim ." Enter
fi

if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "=$session"
else
    tmux attach-session -t "=$session"
fi
