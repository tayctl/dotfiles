#!/usr/bin/env bash

CLOUD="$HOME/Cloud/Uni-sync"
LOCAL="$HOME/Uni"

case "$1" in
    push)
        rsync -avz --delete \
            --info=progress2 \
            --timeout=300 \
            --exclude='.venv' \
            --exclude='__pycache__' \
            --exclude='node_modules' \
            --exclude='*.pyc' \
            "$LOCAL/" "$CLOUD/"
        echo "Pushed to cloud"
        ;;
    pull)
        rsync -avz --delete \
            --info=progress2 \
            --timeout=300 \
            --exclude='.venv' \
            --exclude='__pycache__' \
            --exclude='node_modules' \
            --exclude='*.pyc' \
            "$CLOUD/" "$LOCAL/"
        echo "Pulled from cloud"
        ;;
    *)
        echo "Usage: $0 {push|pull}"
        exit 1
        ;;
esac
