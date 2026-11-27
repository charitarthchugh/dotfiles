#!/usr/bin/env bash
# Set vars
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add PPAs & Other Repositories
sudo add-apt-repository -y ppa:phoerious/keepassxc
# Extrepo
sudo apt install -y extrepo
sudo extrepo enable vscodium
sudo extrepo enable vscode
# Install apt packages (GUI only)
while read package; do
  sudo apt install -y -qq "$package"
  if [[ $? -eq 0 ]]; then
    echo "$package is installed from apt!"
  else
    echo "$package" >>"${BASEDIR}/apt_failed.txt"
  fi
done <"${BASEDIR}/../packages/apt-gui.txt"

# Install packages using pacstall (GUI only)
# while read package; do
# 	yes no | pacstall -I "$package"
# 	if [[ $? -eq 0 ]]; then
# 		echo "$package is installed from pacstall!"
# 	else
# 		echo "$package" >>"${BASEDIR}/pacstall_failed.txt"
# 	fi
# done <"${BASEDIR}/../packages/pacstall-gui.txt"
