#!/usr/bin/env bash

# Run this script to compile tmux-256color support with proper italics
# As instructed at:
# https://web.archive.org/web/20181102111112/https://sookocheff.com/post/vim/italics/

tic -o $HOME/.terminfo tmux.terminfo
tic -o $HOME/.terminfo tmux-256color.terminfo
tic -o $HOME/.terminfo xterm-256color.terminfo
