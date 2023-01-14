#!/usr/bin/env bash


# VSCodium repo
sudo tee -a /etc/yum.repos.d/vscodium.repo << 'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
#VSCode Repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf update -y
# Install dnf packages (gui only)
while read package; do
    sudo dnf install -y -qq "$package"
    if [[ $? -eq 0 ]]; then
        echo "$package is installed from dnf!"
    else
        echo "$package" >>"${BASEDIR}/../dnf_failed.txt"
    fi
done <"${BASEDIR}/../packages/gui-cli.txt"