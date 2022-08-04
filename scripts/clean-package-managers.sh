#!/usr/bin/env bash
if command -v conda &>/dev/null; then
	conda clean -a -y
fi
if command -v apt &>/dev/null; then
	sudo apt autoremove --purge -y
	sudo apt autoclean
fi
if command -v pacman  &> /dev/null; then 
    sudo pacman -R "$(pacman -Qdtq)"
    yes | sudo pacman -Sc  
fi
if command -v flatpak &>/dev/null; then
	flatpak uninstall --unused
fi
if command -v snap &>/dev/null; then
	set -eu
	snap list --all | awk '/disabled/{print $1, $3}' |
		while read snapname revision; do
			echo Removing $snapname
			sudo snap remove "$snapname" --revision="$revision"
		done 
fi
if command -v nix-collect-garbage &> /dev/null; then
  nix-collect-garbage --delete-older-than 15d 
fi
if command -v dnf &> /dev/null; then
  sudo dnf clean all 
  dnf clean all 
fi 
