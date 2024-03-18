#!/usr/bin/env bash
set -e
doas pacman -Syu
qdbus org.kde.Shutdown /Shutdown logoutAndShutdown
