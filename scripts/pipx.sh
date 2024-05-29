#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
while read package; do
    pipx install "$package" >> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "$package is installed from pipx!"
    else
        echo "$package" >> "$BASEDIR/../pipx_failed.txt"
    fi
done < "$BASEDIR/../packages/pipx.txt"
