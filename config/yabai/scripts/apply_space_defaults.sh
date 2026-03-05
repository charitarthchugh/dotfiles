#!/usr/bin/env sh

set -eu

: "${POP_INITIAL_LAYOUT:=bsp}"
: "${POP_OUTER_GAP:=2}"
: "${POP_INNER_GAP:=2}"

apply_space() {
    sid="$1"
    yabai -m config --space "${sid}" layout "${POP_INITIAL_LAYOUT}" >/dev/null 2>&1 || true
    yabai -m config --space "${sid}" top_padding "${POP_OUTER_GAP}" >/dev/null 2>&1 || true
    yabai -m config --space "${sid}" bottom_padding "${POP_OUTER_GAP}" >/dev/null 2>&1 || true
    yabai -m config --space "${sid}" left_padding "${POP_OUTER_GAP}" >/dev/null 2>&1 || true
    yabai -m config --space "${sid}" right_padding "${POP_OUTER_GAP}" >/dev/null 2>&1 || true
    yabai -m config --space "${sid}" window_gap "${POP_INNER_GAP}" >/dev/null 2>&1 || true
}

if [ "${1:-}" != "" ]; then
    apply_space "$1"
    exit 0
fi

# Apply to a reasonable range of spaces without requiring jq.
for sid in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16; do
    apply_space "${sid}"
done
