#!/bin/bash

# Colour temperature presets for waybar wl-gammarelay module
#   temperature-cycle.sh        -> next preset warmer than current (6500 -> 5000 -> 4000 -> 6500)
#   temperature-cycle.sh warm   -> warmest

PRESETS=(6500 5000 4000)
WARMEST=3000

if [[ "$1" == "warm" ]]; then
    target=$WARMEST
else
    current=$(busctl --user get-property rs.wl-gammarelay / rs.wl.gammarelay Temperature | cut -d' ' -f2)
    target=${PRESETS[0]}
    for p in "${PRESETS[@]}"; do
        if (( p < current )); then target=$p; break; fi
    done
fi

busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q "$target"
