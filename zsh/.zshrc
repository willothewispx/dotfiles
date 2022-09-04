#  ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗    ███████╗███████╗██╗  ██╗
# ██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝    ╚══███╔╝██╔════╝██║  ██║
# ██║   ██║███████║    ██╔████╔██║ ╚████╔╝       ███╔╝ ███████╗███████║
# ██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝       ███╔╝  ╚════██║██╔══██║
# ╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║       ███████╗███████║██║  ██║
#  ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝

################################################################################
# Exports
################################################################################

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/opt/homebrew/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export EDITOR="nvim"

ZSH_THEME=robbyrussell

plugins=(docker docker-compose git zsh-vi-mode zsh-autosuggestions fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Dotfiles
export DOTFILES="$HOME/dotfiles"

#-------------------------------------------------------------------------------
# Alias
#-------------------------------------------------------------------------------

# Files
unalias ll
alias ll='exa -l --icons'
unalias la
alias la='exa -la --icons'
alias tree='exa --tree --level=2 --icons'

# Git
unalias gb
alias gb='git branch | fzf-tmux -d 15'

# fzf fuzzy finder keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# zsh-vi-mode breaks fzf keybindings
# see https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

# zoxide
eval "$(zoxide init zsh)"
