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
if type -q fzf
    fzf_configure_bindings
else
    echo "Reminder that fzf is not installed & in path"
end
if type -q starship
    starship init fish | source
    starship completions fish | source
else
    echo "Reminder that starship is not installed & in path"
end
