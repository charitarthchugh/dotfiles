if test -d $HOME/dotfiles
    source $HOME/dotfiles/.env.fish
end
if test -d $HOME/miniconda3
    eval $HOME/miniconda3/bin/conda "shell.fish" hook $argv | source
end
if test -d /home/linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
export BETTER_EXCEPTIONS=1
if command -v fzf > /dev/null
    fzf_configure_bindings
end
if command -v starship > /dev/null
    starship init fish | source
    starship completions fish | source
end