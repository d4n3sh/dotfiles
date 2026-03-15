#!/usr/bin/env bash
# /usr/local/bin/mon_brightness.sh
# usage: mon_brightness.sh up|down|set <value>

BDEVS=(7 8 9)   # i2c buses for your 3 monitors
STEP=5          # step size in percent
cmd="$1"
val="$2"

# Apply brightness change to all monitors via ddcutil
for bus in "${BDEVS[@]}"; do
  case "$cmd" in
    up)
      ddcutil setvcp 10 + "$STEP" --bus "$bus"
      ;;
    down)
      ddcutil setvcp 10 - "$STEP" --bus "$bus"
      ;;
    set)
      ddcutil setvcp 10 "$val" --bus "$bus"
      ;;
  esac
done

# Read current brightness and print on screen using Omarchy's SwayOSD script

current_brightness=$(ddcutil getvcp 10 --bus "${bus}" 2>/dev/null | awk -F'current value =|,' '/current value/ {gsub(/ /,"",$2); print $2}')
omarchy-swayosd-brightness ${current_brightness}
