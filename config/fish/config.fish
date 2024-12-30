if test -d $HOME/dotfiles
    source $HOME/dotfiles/.env.fish
end
if test -d "$HOME/micromamba"
    set -gx MAMBA_ROOT_PREFIX "$HOME/micromamba"
    set -gx MAMBA_EXE "$HOME/.local/bin/micromamba"
    $MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
end    
if test -d $HOME/miniconda3
    eval $HOME/miniconda3/bin/conda "shell.fish" hook $argv | source
end
if test -d /home/linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
if test -d $HOME/.pyenv
   pyenv init - | source
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
if type -q nvim
 set -g EDITOR nvim
end
if type -q direnv
    direnv hook fish | source
end
if type -q howdy 
  set -g OPENCV_LOG_LEVEL 0
  set -g OPENCV_VIDEOIO_PRIORITY_INTEL_MFX 0
end

