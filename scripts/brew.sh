#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Homebrew is installed
if [[ ! -d "/opt/homebrew" ]] && [[ ! -d "/home/linuxbrew" ]]; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Initialize brew in the current shell session
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    else
        # Fallback: try to locate brew now that it's installed
        if command -v brew >/dev/null 2>&1; then
            eval "$(brew shellenv)"
        else
            echo "Error: Homebrew installation reported success, but 'brew' is not in PATH." >&2
            exit 1
        fi
    fi
fi

# Add Homebrew to PATH if needed
if [[ -d "/opt/homebrew" ]]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif [[ -d "/home/linuxbrew" ]]; then
    export PATH="/home/linuxbrew/bin:/home/linuxbrew/sbin:$PATH"
fi

# Determine platform
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Installing on macOS..."
    brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.common"
    brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.tools"
    brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.macos"
else
    echo "Installing on Linux..."
    brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.common"
    brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.tools"
fi

echo "Done!"
