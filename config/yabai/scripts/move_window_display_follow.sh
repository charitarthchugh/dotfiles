#!/usr/bin/env sh

set -eu

target="${1:-east}"

yabai -m window --display "${target}"
yabai -m display --focus "${target}"
