#!/usr/bin/env bash
set -e

# Just stow stuff
targets=(
    bash
    git
    kde
    kitty
    neovim
    tmux
    fish
)
for target in "${targets[@]}"; do
    stow "$target"
done
