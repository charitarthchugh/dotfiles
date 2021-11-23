source $HOME/.config/up/up.fish
source $HOME/dotfiles/.env.fish
if test -d $HOME/miniconda3
    eval $HOME/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
export BETTER_EXCEPTIONS=1
fzf_configure_bindings
starship init fish | source
