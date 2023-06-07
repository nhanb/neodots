#!/usr/bin/env bash
set -e

# Just stow stuff
targets=(
    git
    vim
    tmux
    fish
    gpd-mpc
    yay
)
for target in "${targets[@]}"; do
    stow "$target"
done

doas pacman -Syu jq grim slurp cmus nnn wl-clipboard swappy mpv calc aria2

mkdir ~/Pictures
