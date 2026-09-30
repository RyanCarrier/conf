#!/bin/bash

# Brightness presets for waybar backlight module
#   brightness-cycle.sh       -> next preset above current (low -> medium -> high -> low)
#   brightness-cycle.sh min   -> lowest

PRESETS=(20 50 100)
MIN=1

if [[ "$1" == "min" ]]; then
    target=$MIN
else
    current=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
    target=${PRESETS[0]}
    for p in "${PRESETS[@]}"; do
        if (( p > current )); then target=$p; break; fi
    done
fi

swayosd-client --brightness "$target"
