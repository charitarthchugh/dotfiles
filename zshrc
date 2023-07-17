#Enable Colors
autoload -U colors && colors
# Set up the prompt
#autoload -U promptinit
#promptinit
export TERM=xterm-256color
export HISTCONTROL=ignoreboth
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
zmodload zsh/complist
_comp_options+=(globdots) # Include hidden files.
autoload -Uz +X compinit
compinit
# Sheldon
eval "$(sheldon source)"

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

# Custom ZSH Binds
bindkey '^ ' autosuggest-accept
#
# # Load aliases and shortcuts if existent.
 [ -f "$HOME/dotfiles/aliases/aliasrc" ] && source $HOME/dotfiles/aliases/aliasrc

## Load homebrew if it exists
if [[ -d /home/linuxbrew ]]; then 
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
eval "$(starship init zsh)"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="/home/cc/.local/bin/micromamba";
export MAMBA_ROOT_PREFIX="/home/cc/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    if [ -f "/home/cc/micromamba/etc/profile.d/micromamba.sh" ]; then
        . "/home/cc/micromamba/etc/profile.d/micromamba.sh"
    else
        export  PATH="/home/cc/micromamba/bin:$PATH"  # extra space after export prevents interference from conda init
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<
