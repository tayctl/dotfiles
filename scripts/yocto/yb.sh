#!/usr/bin/env bash
#
# Copyright (c) Sebastian F. Taylor
# License: MIT
#
# yb.sh - Run a command in the team's yocto container
#
# A non-interactive version of the project's scripts/setup_and_run_podman.sh:
# same image, and the project is mounted at ~/yocto like there, so build
# directories work with both. Run it from a build directory, or from the
# project root (the folder with setup.sh) when it has only one build
# directory. setup.sh is sourced first, so bitbake is ready to use.
#
# Usage:
#   cd ~/Projects/ql-yocto/build-skw
#   yb bitbake qcom-console-image
#   yb bitbake -c compile linux-kernel
#   yb                                    # interactive shell
#
# To use another image, for example one built from the Containerfile here:
# export YB_IMAGE="localhost/yocto-build"
#
# Author(s)
#   Sebastian Francis Taylor - sft@sky-watch.com

IMAGE="${YB_IMAGE:-docker.io/prevas/yocto-dev:20250702}"

# The project is the folder with setup.sh, either here or one level up
if [ -f setup.sh ]; then
    project="$PWD"
elif [ -f ../setup.sh ]; then
    project=$(dirname "$PWD")
else
    echo "run yb from a yocto project (the folder with setup.sh) or a build directory"
    exit 1
fi

# The same directory, seen from inside the container
workdir="$HOME/yocto${PWD#"$project"}"

# From the project root, use the build directory if there is only one
if [ "$PWD" = "$project" ] && [ $# -gt 0 ]; then
    builddirs=(*/conf/local.conf)
    if [ ${#builddirs[@]} -eq 1 ] && [ -f "${builddirs[0]}" ]; then
        workdir="$workdir/${builddirs[0]%/conf/local.conf}"
    else
        echo "cd into a build directory first, found: ${builddirs[*]%/conf/local.conf}"
        exit 1
    fi
fi

# Only use a terminal when we have one, so yb also works in pipes and CI
tty=""
if [ -t 0 ]; then
    tty="--tty"
fi

mkdir -p "$HOME/.yocto-cache"

# Git identity as seen from the project, so per-remote includes (and a
# home-manager git config living in the nix store) still apply in the container
gitopts=(
    --env GIT_AUTHOR_NAME="$(git -C "$project" config user.name)"
    --env GIT_AUTHOR_EMAIL="$(git -C "$project" config user.email)"
    --env GIT_COMMITTER_NAME="$(git -C "$project" config user.name)"
    --env GIT_COMMITTER_EMAIL="$(git -C "$project" config user.email)"
)
if [ -f "$HOME/.gitconfig" ]; then
    gitopts+=(--volume "$HOME/.gitconfig:$HOME/.gitconfig:ro")
fi

exec podman run --rm --interactive $tty \
    --userns=keep-id \
    --passwd-entry "$USER:*:$(id -u):$(id -g)::$HOME:/bin/bash" \
    --env HOME="$HOME" \
    --security-opt label=disable \
    --hostname skw-yocto-dev \
    --volume "$project:$HOME/yocto" \
    --volume "$HOME/.yocto-cache:$HOME/.yocto-cache" \
    --volume "$HOME/.ssh:$HOME/.ssh:ro" \
    "${gitopts[@]}" \
    --workdir "$workdir" \
    "$IMAGE" \
    bash -c '
        # In a build directory, set up bitbake with the project setup.sh.
        # Always pass the build directory, otherwise setup.sh sees our
        # arguments as its own
        if [ -f ../setup.sh ] && [ -f conf/local.conf ]; then
            source ../setup.sh "$PWD"
        fi
        "${@:-bash}"' yb "$@"
