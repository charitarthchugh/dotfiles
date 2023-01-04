#!/usr/bin/env bash
# Set vars
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add PPAs & Other Repositories
sudo add-apt-repository -y ppa:phoerious/keepassxc
sudo add-apt-repository -y ppa:appimagelauncher-team/stable
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

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
