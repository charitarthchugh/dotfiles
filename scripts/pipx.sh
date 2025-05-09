#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Function to check if a package is already installed via pipx
is_installed() {
    pipx list | grep -q "$1"
    return $?
}

# Use jq to parse the JSON and install each pipx tool and its injected dependencies
jq -c '.venvs | to_entries[]' "$BASEDIR/../packages/pipx-packages.json" | while read -r entry; do
    # Extract the package name and its injected packages
    package_name=$(echo "$entry" | jq -r '.key')
    injected_packages=$(echo "$entry" | jq -r '.value.metadata.injected_packages | keys[]')

    # Check if the main package is already installed
    if ! is_installed "$package_name"; then
        echo "Installing $package_name..."
        pipx install "$package_name"
    else
        echo "$package_name is already installed."
    fi

    # Install injected packages
    for injected_package in $injected_packages; do
        if ! is_installed "$injected_package"; then
            echo "Installing injected package $injected_package for $package_name..."
            pipx inject "$package_name" "$injected_package"
        else
            echo "Injected package $injected_package is already installed."
        fi
    done
done

echo "All pipx tools and their injected dependencies have been processed."
