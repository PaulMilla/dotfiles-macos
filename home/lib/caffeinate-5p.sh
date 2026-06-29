#!/usr/bin/env bash
set -euo pipefail

TARGET_HOUR=17  # 5:00 PM

now_seconds=$(date +%s)
target_seconds=$(date -j -f "%H:%M:%S" "${TARGET_HOUR}:00:00" +%s 2>/dev/null)

seconds_remaining=$(( target_seconds - now_seconds ))

if (( seconds_remaining <= 0 )); then
    echo "Error: it is already past 5:00 PM." >&2
    exit 1
fi

hours=$(( seconds_remaining / 3600 ))
minutes=$(( (seconds_remaining % 3600) / 60 ))

echo "Caffeinating until 5:00 PM (${hours}h ${minutes}m from now)..."
echo "Press CTRL+C to stop at any time"
exec caffeinate -d -t "${seconds_remaining}"
