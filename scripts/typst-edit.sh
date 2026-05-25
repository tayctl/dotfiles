#!/bin/bash
# typst-edit - compile and open a Typst document in Zathura
#
# Uses Typst for compilation and Zathura for PDF viewing.
#
# Usage:
#   typst-edit main.typ
#
# Copyright (c) 2026 Sebastian F. Taylor
# Released under the MIT License.

file="$1"
pdf="${file%.typ}.pdf"

sanity_check() {
    if [ -z "$file" ]; then
        echo "usage: $(basename "$0") <file.typ>"
        exit 1
    fi

    if [ ! -f "$file" ]; then
        echo "file does not exist: $file"
        exit 1
    fi

    if [[ "$file" != *.typ ]]; then
        echo "expected a .typ file"
        exit 1
    fi

    if ! command -v typst >/dev/null 2>&1; then
        echo "typst not installed"
        exit 1
    fi

    if ! command -v zathura >/dev/null 2>&1; then
        echo "zathura not installed"
        exit 1
    fi
}

main() {
    sanity_check

    typst compile "$file" "$pdf" || {
        echo "initial compile failed"
        exit 1
    }

    zathura "$pdf" &
    typst watch "$file" "$pdf"
}

main
