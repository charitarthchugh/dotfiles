#!/usr/bin/env sh

set -eu

# Prefer an installed app launcher; fallback to Spotlight hotkey.
if open -Ra "Raycast" >/dev/null 2>&1; then
    open -a "Raycast"
elif open -Ra "Alfred 5" >/dev/null 2>&1; then
    open -a "Alfred 5"
else
    osascript -e 'tell application "System Events" to key code 49 using {command down}'
fi
