#!/usr/bin/env bash
# Set vars
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo dnf upgrade -y

# Add tailscle repo
sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
# Install dnf packages (cli only)
while read package; do
    sudo dnf install -y -qq "$package"
    if [[ $? -eq 0 ]]; then
        echo "$package is installed from dnf!"
    else
        echo "$package" >>"${BASEDIR}/../dnf_failed.txt"
    fi
done <"${BASEDIR}/../packages/dnf-cli.txt"

# Auto Install Nix & Home Manager
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source "$HOME/.nix-profile/etc/profile.d/nix.sh"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install
home-manager switch

sudo systemctl enable --now tailscaled
