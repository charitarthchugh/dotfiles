#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
while read -r package; do
  gnome-extensions-cli install "$package" >>/dev/null

  if [[ $? -eq 0 ]]; then
    echo "$package is installed from gnome shell extensions!"
  else
    echo "$package" >>"$BASEDIR/../gnome_shell_ext_failed.txt"
  fi
done <"$BASEDIR/../packages/gnome-shell-ext.txt"
echo "Make sure to relogin to activate the newly installed extensions!"
