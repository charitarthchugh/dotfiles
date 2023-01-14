#!/usr/bin/env bash

# Install apt packages (cli only)
while read package; do
	yay -S --needed -y "$package"
	if [[ $? -eq 0 ]]; then
		echo "$package is installed from yay!"
	else
		echo "$package" >>"${BASEDIR}/../yay_failed.txt"
	fi
done <"${BASEDIR}/../packages/yay-gui.txt"