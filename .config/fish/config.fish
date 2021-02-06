#/usr/bin/colorscript -r
source ~/.config/up/up.fish
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/ccd12/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
export BETTER_EXCEPTIONS=1
# Homebrew completions
if test -d (brew --prefix)"/share/fish/completions"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end
starship init fish | source
