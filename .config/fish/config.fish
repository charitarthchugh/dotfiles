
source $HOME/.config/up/up.fish
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval $HOME/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
export BETTER_EXCEPTIONS=1

starship init fish | source
