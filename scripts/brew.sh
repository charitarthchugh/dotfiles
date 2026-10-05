#!/usr/bin/env bash
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#
# # Check if Homebrew is installed
# if [[ ! -d "/opt/homebrew" ]] && [[ ! -d "/home/linuxbrew/.linuxbrew" ]]; then
# 	echo "Installing Homebrew..."
# 	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#
# 	# Initialize brew in the current shell session
# 	if [[ -x /opt/homebrew/bin/brew ]]; then
# 		eval "$(/opt/homebrew/bin/brew shellenv)"
# 	elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
# 		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# 	elif [[ -x /usr/local/bin/brew ]]; then
# 		eval "$(/usr/local/bin/brew shellenv)"
# 	else
# 		# Fallback: try to locate brew now that it's installed
# 		if command -v brew >/dev/null 2>&1; then
# 			eval "$(brew shellenv)"
# 		else
# 			echo "Error: Homebrew installation reported success, but 'brew' is not in PATH." >&2
# 			exit 1
# 		fi
# 	fi
# fi
#
# # Add Homebrew to PATH if needed
# #if [[ -d "/opt/homebrew" ]]; then
# #	export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
# #elif [[ -d "/home/linuxbrew" ]]; then
# #	export PATH="/home/linuxbrew/.linuxbrew/:/home/linuxbrew/.linuxbrew/sbin:$PATH"
# #fi
# if [[ -x "/opt/homebrew/bin/brew" ]]; then
#     eval "$(/opt/homebrew/bin/brew shellenv)"
# else
#     eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# fi
#
# # Determine platform
# if [[ "$(uname)" == "Darwin" ]]; then
# 	echo "Installing on macOS..."
# 	brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.common"
# 	brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.tools"
# 	brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.macos"
# else
# 	echo "Installing on Linux..."
# 	brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.common"
# 	brew bundle --file="$BASEDIR/../packages/Brew/Brewfile.tools"
# fi
#!/usr/bin/env bash

set -e

# Resolve script directory
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found."

  if [[ "$(uname)" == "Linux" ]]; then
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"

    # Homebrew's Linux installer requires the prefix to be writable
    # by the user running this script. If it doesn't exist or isn't
    # writable, use sudo only to create/fix the prefix.
    if [[ ! -d "$BREW_PREFIX" ]] || [[ ! -w "$BREW_PREFIX" ]]; then
      echo "Homebrew prefix is missing or not writable:"
      echo "  $BREW_PREFIX"
      echo
      echo "Administrator privileges are required to prepare the directory."
      echo

      sudo mkdir -p "$BREW_PREFIX"
      sudo chown -R "$(id -u):$(id -g)" "$BREW_PREFIX"
    fi

    # Verify that the prefix is now writable
    if [[ ! -w "$BREW_PREFIX" ]]; then
      echo "Error: $BREW_PREFIX is still not writable by $(whoami)." >&2
      exit 1
    fi
  fi

  echo "Installing Homebrew..."

  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Initialize Homebrew in the current shell session
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
else
  echo "Error: Homebrew installation failed, but 'brew' was not found." >&2
  exit 1
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
