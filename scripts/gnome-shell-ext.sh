#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
while read package; do
    gnome-extensions install "$package" >> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "$package is installed from gnome shell extensions!"
    else
        echo "$package" >> "$BASEDIR/../gnome_shell_ext_failed.txt"
    fi
done < "$BASEDIR/../packages/pipx.txt"
echo "Make sure to relogin to activate the newly installed extensions!"
