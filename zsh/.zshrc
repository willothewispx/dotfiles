# ███████╗███████╗██╗  ██╗
# ╚══███╔╝██╔════╝██║  ██║
#   ███╔╝ ███████╗███████║
#  ███╔╝  ╚════██║██╔══██║
# ███████╗███████║██║  ██║
# ╚══════╝╚══════╝╚═╝  ╚═╝

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

# PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/go/bin:$PATH

# Editor
export EDITOR="nvim"

[ -f $HOME/.zprofile ] && source $HOME/.zprofile

#-------------------------------------------------------------------------------
# Alias
#-------------------------------------------------------------------------------

# Files
alias ..='cd ..'
alias ll='eza -l --icons'
alias la='eza -la --icons --git'
alias tree='eza --tree --level=2 --icons'

# Git
alias gb='git branch | fzf-tmux -d 15'

# starship prompt
eval "$(starship init zsh)"
# fzf
eval "$(fzf --zsh)"
# zoxide
eval "$(zoxide init zsh)"

# Plugins
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load
