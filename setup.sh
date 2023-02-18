#!/usr/bin/env bash
set -e

# Just stow stuff
targets=(
    bash
    git
    kde
    kitty
    vim
    tmux
    fish
    mpv
)
for target in "${targets[@]}"; do
    stow "$target"
done
