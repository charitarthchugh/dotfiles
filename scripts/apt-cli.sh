#!/usr/bin/env bash
# Set vars
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Update Everything
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

#Add PPAs
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-add-repository -y ppa:fish-shell/release-3

# Install apt packages (cli only)
while read package; do
	sudo apt install -y -qq "$package"
	if [[ $? -eq 0 ]]; then
		echo "$package is installed from apt!"
	else
		echo "$package" >>"${BASEDIR}/apt_failed.txt"
	fi
done <"${BASEDIR}/../packages/apt-cli.txt"
# # Install pacstall
# yes | sudo bash -c "$(curl -fsSL https://git.io/JsADh || wget -q https://git.io/JsADh -O -)"

# # Install packages using pacstall (cli only)
# while read package; do
# 	sudo apt install -y -qq "$package"
# 	if [[ $? -eq 0 ]]; then
# 		echo "$package is installed from pacstall!"
# 	else
# 		echo "$package" >>"${BASEDIR}/pacstall_failed.txt"
# 	fi
# done <"${BASEDIR}/../packages/pacstall-cli.txt"
