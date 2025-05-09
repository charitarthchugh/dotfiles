#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v cargo > /dev/null 2>&1;then
  echo 'using existing cargo'
else
  echo "Installing cargo via rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal
  source ~/.cargo/bin/env
fi

while read package; do
    cargo install "$package" >> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "$package is installed from cargo!"
    else
        echo "$package" >> "$BASEDIR/../cargo_failed.txt"
    fi
done < "$BASEDIR/../packages/cargo.txt"
