#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
while read package; do
    gh extension install "$package" >> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "$package is installed from gh!"
    else
        echo "$package" >> "$BASEDIR/../gh_failed.txt"
    fi
done < "$BASEDIR/../packages/gh-extensions.txt"