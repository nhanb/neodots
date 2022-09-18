#!/usr/bin/env fish

# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# Produces "21 days", for example
set uptime_formatted (uptime | cut -d ',' -f1  | cut -d ' ' -f4,5)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
set date_formatted (date "+%a %d %b %I:%M %p")

# Returns the battery status: "Full", "Discharging", or "Charging".
set battery_status (cat /sys/class/power_supply/BAT1/status)
if [ $battery_status = 'Charging' ]
    set bstatus '⚡'
else
    set bstatus ''
end

set battery_capacity (cat /sys/class/power_supply/BAT1/capacity)

set volume (pulsemixer --get-volume | cut -d ' ' -f1)
if [ (pulsemixer --get-mute) = '1' ]
    set volume_icon '🔇'
else
    set volume_icon '🔊'
end

set brightness (math (brightnessctl get) / (brightnessctl max) x 100)

if bluetoothctl show | grep 'Powered: yes' &>/dev/null
    # There's no bluetooth glyph so here's a poor man's
    # approximation instead
    set bluetooth_status 'ᛒ'
    if bluetoothctl info | grep 'input-mouse' &>/dev/null
        set bluetooth_status "$bluetooth_status🖱️"
    end
else
    set bluetooth_status ''
end

# Emojis and characters for the status bar
echo $bluetooth_status 💻$uptime_formatted 🔆$brightness $volume_icon$volume 🔋$battery_capacity $bstatus $date_formatted
