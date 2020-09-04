#Enable Colors
autoload -U colors && colors
# Set up the prompt
autoload -U promptinit
promptinit
#enable Antibody
source <(antibody init)
#Source Plugins
antibody bundle < ~/dotfiles/.zsh_plugins.txt
export TERM=xterm-256color
export HISTCONTROL=ignoreboth

setopt histignorealldups sharehistory


# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

zmodload zsh/complist
compinit
_comp_options+=(globdots)               # Include hidden files.
autoload -Uz compinit && compinit


# Custom ZSH Binds
bindkey '^ ' autosuggest-accept
#
# # Load aliases and shortcuts if existent.
 [ -f "$HOME/dotfiles/aliases/aliasrc" ] && source $HOME/dotfiles/aliases/aliasrc
#Enhacd options
ENHANCD_FILTER=fzf; export ENHANCD_FILTER

# Add Homebrew to PATH
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH" 
# Local Bin
export PATH="$HOME/.local/bin:$PATH"
# # Load ; should be last.
export GEM_HOME="$HOME/gems" 

source "$HOME/dotfiles/.condainit"

colorscript random

