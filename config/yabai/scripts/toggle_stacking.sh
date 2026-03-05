#!/usr/bin/env sh

set -eu

space_type="$(yabai -m query --spaces --space | sed -n 's/.*"type"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"

if [ "${space_type}" = "stack" ]; then
    yabai -m space --layout bsp
else
    yabai -m space --layout stack
fi
