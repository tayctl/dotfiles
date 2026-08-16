#!/bin/bash
# temp-clean.sh
#
# Removes files and directories in $HOME/temp that haven't been modified
# in the last 30 days. Intended to be run once at login/boot.
#
# Copyright 2026, Sebastian F. Taylor
# May be used under the terms of the MIT License.

set -euo pipefail

tempdir="$HOME/temp"

# Do nothing if $HOME/temp doesn't exist.
[[ -d "$tempdir" ]] || exit 0

# Delete files, symlinks and directories older than 30 days.
find "$tempdir" -mindepth 1 -type f -mtime +30 -delete
find "$tempdir" -mindepth 1 -type l -mtime +30 -delete
find "$tempdir" -mindepth 1 -type d -empty -mtime +30 -delete
