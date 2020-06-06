#Enable Colors
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
# Set up the prompt
fpath+=$HOME/.zsh/pure
autoload -U promptinit
promptinit
prompt pure
#enable Antigen
source ~/antigen.zsh
# Load the oh-my-zsh's library.
antigen use oh-my-zsh
export TERM=xterm-256color
export HISTCONTROL=ignoreboth
# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle colorize
# Custom plugins
# From Default(Oh-My-Zsh)
antigen bundle github
antigen bundle gitignore
antigen bundle colored-man-pages
antigen bundle vundle
antigen bundle web-search
antigen bundle ubuntu
antigen bundle brew
antigen bundle git-auto-fetch
# From Github
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle arzzen/calc.plugin.zsh
antigen bundle MichaelAquilina/zsh-you-should-use
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
# Tell Antigen that you're done.
antigen apply

setopt histignorealldups sharehistory


# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

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



# Custom ZSH Binds
bindkey '^ ' autosuggest-accept
#
# # Load aliases and shortcuts if existent.
 [ -f "$HOME/dotfiles/aliases/aliasrc" ] && source "$HOME/dotfiles/aliases/aliasrc"
# Load a fun ASCII Pacman Ghost
 [ -f "$HOME/dotfiles/aliases/pacman1" ] && cat $HOME/dotfiles/aliases/pacman1 | lolcat
# Add Homebrew to PATH
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
# Flutter command
 export PATH="$PATH:$HOME/Dev/flutter/bin"
 #Dart Pub command+Pub executables 
 export PATH="$PATH:/usr/lib/dart/bin"
 export PATH="$PATH":"$HOME/.pub-cache/bin"
# # Load ; should be last.
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/autojump/autojump.zsh 2>/dev/null
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
export GEM_HOME="$HOME/gems"
