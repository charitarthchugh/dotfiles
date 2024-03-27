#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sudo pacman -Syu
if [ ! -n "$(pacman -Qs yay)" ]; then

    # Install yay
    # Install build tools
    sudo pacman -S --no-confirm --needed binutils make gcc fakeroot
    sudo pacman -S --no-confirm --needed --asdeps git go sudo

    mkdir -p /tmp/yay_install
    cd /tmp/yay_install
    curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=yay
    makepkg PKGBUILD --install --needed
    cd ~
    rm -r /tmp/yay_install
fi
# Install apt packages (cli only)
while read package; do
	yay -S --needed -y "$package"
	if [[ $? -eq 0 ]]; then
		echo "$package is installed from yay!"
	else
		echo "$package" >>"${BASEDIR}/../yay_failed.txt"
	fi
done <"${BASEDIR}/../packages/yay-cli.txt"
