#!/usr/bin/env bash
set -e

# Just stow stuff
targets=(
    bash
    git
    vim
    tmux
    fish
    tiger
)
for target in "${targets[@]}"; do
    stow "$target"
done
