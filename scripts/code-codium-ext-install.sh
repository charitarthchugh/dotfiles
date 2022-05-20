#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rm -rf ~/.vscode
rm -rf ~/.vscode-oss
while read package; do
    codium --install-extension "$package" >> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "$package is installed from codium!"
    else
        echo "$package" >>codium_failed.txt
    fi
done < "$BASEDIR/../packages/codium-extensions.txt"
while read package; do
    code --install-extension "$package" >> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "$package is installed from code!"
    else
        echo "$package" >>code_failed.txt
    fi
done < "$BASEDIR/../packages/code-extensions.txt"
