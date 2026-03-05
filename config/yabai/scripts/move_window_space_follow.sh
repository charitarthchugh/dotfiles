#!/usr/bin/env sh

set -eu

target="${1:-next}"

yabai -m window --space "${target}"
yabai -m space --focus "${target}"
