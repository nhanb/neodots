#!/usr/bin/env bash
set -e

icon=gnome-volume-control

if [ "$1" = "up" ]; then
    sign='+'
else
    sign='-'
fi

pactl set-sink-volume @DEFAULT_SINK@ "$sign"5%
notify-send -i "$icon" `pulsemixer --get-volume | cut -d ' ' -f1`
