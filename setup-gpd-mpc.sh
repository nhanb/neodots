#!/usr/bin/env bash
set -e

# Just stow stuff
targets=(
    git
    neovim
    tmux
    fish
    gpd-mpc
)
for target in "${targets[@]}"; do
    stow "$target"
done

doas pacman -Syu jq grim slurp cmus nnn wl-clipboard swappy

mkdir ~/Pictures