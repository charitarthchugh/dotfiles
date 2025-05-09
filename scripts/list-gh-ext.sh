#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rm "$BASEDIR/../packages/gh-extensions.txt"
while read -r line; do
    for word in $line; do 
        if [[ $word == *"/"* ]]; then 
            echo $word >> "$BASEDIR/../packages/gh-extensions.txt"
        fi
    done
done <<< "$(gh extension list)"