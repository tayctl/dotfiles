#!/bin/bash 
# fcd.sh - Fuzzily find directories and Tmux sessions
#
# Uses fzf for searching predefine paths (via $FCD_SEARCH_DIRS) and detached
# tmux sessions. Checks if the tools are installed or not and reports back to
# the user.
#
# Define the directories to be searched in your bashrc or zshrc like this:
# export FCD_SEARCH_DIRS="$HOME/Documents $HOME/Projects \
#     $HOME/Uni $HOME/dotfiles"
#
# Copyright 2026, Sebastian F. Taylor
# May be used under the terms of the MIT License.


# Function sanity_check
# checks that the relevant programs are installed on the machine before running the script
sanity_check() {
    if ! command -v tmux >/dev/null 2>&1
    then 
        echo "tmux not installed"
        exit 1
    fi

    if ! command -v nvim >/dev/null 2>&1
    then 
        echo "nvim not installed"  
        exit 1
    fi

    if ! command -v fzf >/dev/null 2>&1
    then 
        echo "fzf not installed"
        exit 1
    fi

    if [ -z "$FCD_SEARCH_DIRS" ]; then
        echo "FCD_SEARCH_DIRS is not set"
        exit 1
    fi
}

find_directories() {
    # Get active tmux sessions with their working directories
    # Format: "session_name (or number) -> working_directory"
    local fmt="TMUX_SESSION:#{session_name} -> #{session_path}"
    tmux_sessions=$(tmux list-sessions -F "$fmt" 2>/dev/null \
        | sed 's/^TMUX_SESSION:/\x1b[32m[ TMUX ]\x1b[0m /')
    
    file_dirs=$(find $FCD_SEARCH_DIRS \
        -type d \( \
            -name ".cache" \
            -o -name "node_modules" \
            -o -name ".git" \
            -o -name ".venv" \
            -o -name "bin" \
        \) -prune \
        -o -type d -print 2>/dev/null)
    
    # Combine directories and tmux sessions and pipe to fzf
    selection=$(printf "%s\n%s" "$tmux_sessions" "$file_dirs" | fzf --ansi)
    
    # If a tmux session was selected, extract the session name and switch to it
    if [[ "$selection" == *"[ TMUX ]"* ]]; then 
        session_name=$(echo "$selection" \
            | sed 's/\x1b\[[0-9;]*m//g' \
            | sed 's/\[ TMUX \] \(.*\) ->.*/\1/')
        tmux switch-client -t "$session_name" 2>/dev/null \
            || tmux attach -t "$session_name"
        exit 0
    fi
    
    dir="$selection"
}

main() {
    sanity_check  
    find_directories

    if [ -z "$dir" ]; then
        exit 0
    fi

    if [ -z "$TMUX" ]; then
        tmux new-session -c "$dir" \; send-keys "nvim ." Enter
    else
        cd "$dir" && nvim .
    fi
}

main
