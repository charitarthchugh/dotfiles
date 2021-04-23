ZPLUG_CACHE_DIR="$HOME/.cache/zplug"
source ~/.zplug/init.zsh
#Let zplug manage itself
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
#base
zplug "zsh-users/zsh-syntax-highlighting", defer:2, from:github
zplug "zsh-users/zsh-history-substring-search", from:github
zplug "zsh-users/zsh-autosuggestions", from:github
zplug "zsh-users/zsh-completions", from:github
# Oh My Zsh
zplug "plugins/command-not-found",   from:oh-my-zsh
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/pip",   from:oh-my-zsh
zplug "plugins/github",   from:oh-my-zsh
zplug "plugins/ubuntu",   from:oh-my-zsh
zplug "plugins/common-aliases",   from:oh-my-zsh
zplug "plugins/flutter",   from:oh-my-zsh
# Inidividial Github Plugins
zplug "zpm-zsh/undollar", as:command 
zplug "esc/conda-zsh-completion"
if zplug check || zplug install; then
  zplug load
fi