#!/usr/bin/env bash
set -euo pipefail

# Ensure Homebrew is installed (auto-installs if missing), then install packages from the project's Brewfile.

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
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
else
  # Ensure brew env is loaded for this session
  eval "$(brew shellenv)"
fi

# Quiet, non-interactive env for CI/bootstrap
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_COLOR=1

echo "Installing packages from Brewfile at: $BREWFILE_PATH"
brew bundle --file="$BASEDIR/packages/Brewfile"
# If on MacOS, install casks
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew bundle --file="$BASEDIR/packages/Brewfile.cask"
fi
echo "All done."