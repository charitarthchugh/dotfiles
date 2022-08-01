#!/usr/bin/env bash
# Set vars
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# Disable any filters, if present
flatpak remote-modify flathub --no-filter                

# Install flatpak apps
while read package; do
	flatpak install flathub "$package" -y
	if [[ $? -eq 0 ]]; then
		echo "$package is installed from flatpak!"
	else
		echo "$package" >>"${BASEDIR}/flatpak_failed.txt"
	fi
done <"${BASEDIR}/../packages/flatpak.txt"
