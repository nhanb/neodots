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
    mpv
)
for target in "${targets[@]}"; do
    stow "$target"
done

ln -s "$PWD/neovim/.config/nvim/init.vim" ~/.vimrc
