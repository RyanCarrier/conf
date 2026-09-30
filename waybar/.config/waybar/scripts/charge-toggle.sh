#!/bin/bash

# Cycle battery charge mode: Fast -> Standard -> Long_Life -> Fast
# Needs write access to charge_types (see root/etc/udev/rules.d/99-battery-charge-types.rules)

FILE="/sys/class/power_supply/BAT0/charge_types"

[[ -r "$FILE" ]] || exit 0

current=$(grep -o '\[[^]]*\]' "$FILE" | tr -d '[]')

case "$current" in
    Fast)     next=Standard ;;
    Standard) next=Long_Life ;;
    *)        next=Fast ;;
esac

if ! echo "$next" > "$FILE" 2>/dev/null; then
    notify-send -u critical "Charge mode" "No write access to $FILE — install the udev rule"
    exit 1
fi

# Refresh the waybar module immediately
pkill -RTMIN+9 waybar
