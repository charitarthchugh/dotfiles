#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
while read package; do
    codium --install-extension "$package"
    if [[ $? -eq 0 ]]; then
        echo "$package is installed from codium!"
    else
        echo "$package" >>apt_failed.txt
    fi
done <"$BASEDIR/packages/codium-extensions.txt"