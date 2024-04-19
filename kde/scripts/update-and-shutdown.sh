#!/usr/bin/env bash
set -e
doas pacman -Syu
qdbus6 org.kde.Shutdown /Shutdown logoutAndShutdown
