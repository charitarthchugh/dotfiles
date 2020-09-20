#!/bin/zsh
ln -s $HOME/dotfiles/theming/firefox/MaterialFox/user.js $HOME/.mozilla/firefox/school/user.js || return 1
ln -s $HOME/dotfiles/theming/firefox/MaterialFox/user.js $HOME/.mozilla/firefox/Personal/user.js || return 1
ln -s $HOME/dotfiles/theming/firefox/MaterialFox/chrome $HOME/.mozilla/firefox/Personal/chrome || return 1
ln -s $HOME/dotfiles/theming/firefox/MaterialFox/chrome $HOME/.mozilla/firefox/school/chrome || return 1
antibody bundle < ~/dotfiles/.zsh_plugins.txt > ~/dotfiles/.zsh_plugins.sh

