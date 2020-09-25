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

# Emojis and characters for the status bar
echo 💻$uptime_formatted 🔋$battery_capacity% $bstatus $date_formatted
