#!/bin/bash

# Caffeine mode toggle script for waybar
# Prevents system from sleeping when lid is closed

STATE_FILE="/tmp/caffeine-mode-state"
PID_FILE="/tmp/caffeine-mode-pid"
LOCK_FILE="/tmp/caffeine-mode-lock"

# File locking to prevent race conditions
exec 200>"$LOCK_FILE"
flock -n 200 || exit 1

# Initialize state file if it doesn't exist
if [[ ! -f "$STATE_FILE" ]]; then
    echo "0" > "$STATE_FILE"
fi

# Read current state
current_state=$(cat "$STATE_FILE")

if [[ "$current_state" == "0" ]]; then
    # Turn ON caffeine mode
    # Start systemd-inhibit in the background
    systemd-inhibit \
        --what=handle-lid-switch:sleep:idle \
        --who="Caffeine Mode" \
        --why="User requested system to stay awake" \
        sleep infinity &

    # Save the PID
    echo $! > "$PID_FILE"

    # Update state
    echo "1" > "$STATE_FILE"
else
    # Turn OFF caffeine mode
    if [[ -f "$PID_FILE" ]]; then
        pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
        fi
        rm -f "$PID_FILE"
    fi

    # Update state
    echo "0" > "$STATE_FILE"
fi

# Release lock
flock -u 200
