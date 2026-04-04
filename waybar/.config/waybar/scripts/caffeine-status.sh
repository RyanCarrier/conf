#!/bin/bash

# Caffeine mode status script for waybar
# Displays current caffeine mode status

STATE_FILE="/tmp/caffeine-mode-state"
PID_FILE="/tmp/caffeine-mode-pid"

# Initialize state file if it doesn't exist
if [[ ! -f "$STATE_FILE" ]]; then
    echo "0" > "$STATE_FILE"
fi

# Read current state
current_state=$(cat "$STATE_FILE")

# Verify the process is actually running
active=false
if [[ "$current_state" == "1" ]] && [[ -f "$PID_FILE" ]]; then
    pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
        active=true
    else
        # Process died, reset state
        echo "0" > "$STATE_FILE"
        rm -f "$PID_FILE"
    fi
fi

# Output JSON for waybar
if [[ "$active" == true ]]; then
    echo '{"text":"☕","tooltip":"Caffeine Mode: Active\nSystem will not sleep when lid is closed","class":"active"}'
else
    echo '{"text":"󰒲","tooltip":"Caffeine Mode: Inactive\nSystem will sleep normally","class":"inactive"}'
fi
