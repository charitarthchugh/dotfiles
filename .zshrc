#Enable Colors
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
# Set up the prompt
autoload -U promptinit
promptinit
#enable Antibody
source <(antibody init)
#Source Plugins
antibody bundle < ~/dotfiles/.zsh_plugins.txt
export TERM=xterm-256color
export HISTCONTROL=ignoreboth
# Bundles from the default repo (robbyrussell's oh-my-zsh).

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
 [ -f "$HOME/dotfiles/aliases/aliasrc" ] && source "$HOME/dotfiles/aliases/aliasrc"
# Load a fun ASCII Pacman Ghost
 [ -f "$HOME/dotfiles/aliases/pacman1" ] && cat $HOME/dotfiles/aliases/pacman1 | lolcat

#Enhacd options
ENHANCD_FILTER=fzf; export ENHANCD_FILTER


# Add Homebrew to PATH
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
# Flutter command
export PATH="$PATH:$HOME/Dev/SDK/flutter/bin" 
# Local Bin
export PATH="$HOME/.local/bin:$PATH"
# # Load ; should be last.
export GEM_HOME="$HOME/gems" 

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ccd12/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ccd12/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ccd12/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/ccd12/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

