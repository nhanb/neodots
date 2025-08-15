#!/usr/bin/env bash
set -e
sudo pacman -Syu
qdbus6 org.kde.Shutdown /Shutdown logoutAndShutdown
