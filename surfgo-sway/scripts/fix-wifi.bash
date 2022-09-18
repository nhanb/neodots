#!/usr/bin/env bash
set -e
dir1='/usr/lib/firmware/ath10k/QCA6174/hw2.1'
dir2='/usr/lib/firmware/ath10k/QCA6174/hw3.0'

# Assumes board.bin exists in current dir.
# If not, download here first:
# https://www.killernetworking.com/support/K1535_Debian/board.bin
# Can't reliably download using curl because of cloudflare shenanigans.
doas cp "board.bin" "$dir1/board.bin"
doas cp "$dir1/board.bin" "$dir2/board.bin"
doas rm -f "$dir1/board-2.bin"
doas rm -f "$dir2/board-2.bin"
