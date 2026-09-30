#!/bin/bash

# Battery charge mode status for waybar
# Fast = rapid charge to 100%, Standard = normal to 100%, Long_Life = conservation (~80%)

FILE="/sys/class/power_supply/BAT0/charge_types"

# No battery / no support (e.g. desktop): empty text hides the module
[[ -r "$FILE" ]] || { echo '{"text":""}'; exit 0; }

current=$(grep -o '\[[^]]*\]' "$FILE" | tr -d '[]')
hint="\nClick to cycle: 🐇100 → 🐢100 → 🐢80"

case "$current" in
    Fast)      echo "{\"text\":\"🐇100\",\"tooltip\":\"Charge: Rapid to 100%$hint\",\"class\":\"fast\"}" ;;
    Standard)  echo "{\"text\":\"🐢100\",\"tooltip\":\"Charge: Standard to 100%$hint\",\"class\":\"standard\"}" ;;
    Long_Life) echo "{\"text\":\"🐢80\",\"tooltip\":\"Charge: Conservation (~80%)$hint\",\"class\":\"longlife\"}" ;;
    *)         echo "{\"text\":\"🔋?\",\"tooltip\":\"Charge: unknown mode '$current'\"}" ;;
esac
