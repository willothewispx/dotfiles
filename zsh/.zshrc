#  ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗    ███████╗███████╗██╗  ██╗
# ██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝    ╚══███╔╝██╔════╝██║  ██║
# ██║   ██║███████║    ██╔████╔██║ ╚████╔╝       ███╔╝ ███████╗███████║
# ██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝       ███╔╝  ╚════██║██╔══██║
# ╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║       ███████╗███████║██║  ██║
#  ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝

################################################################################
# Exports
################################################################################

# ToDo: Do we need these?
# Language
# export LANGUAGE=en_US.UTF-8
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8

# PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/opt/homebrew/bin:$PATH

# Editor
# export EDITOR="nvim"

# Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"


# ZSH_THEME="spaceship"

# plugins=(docker docker-compose git zsh-vi-mode zsh-autosuggestions fast-syntax-highlighting)

# source $ZSH/oh-my-zsh.sh

# Dotfiles
# export DOTFILES="$HOME/dotfiles"

# nvm node manager
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#-------------------------------------------------------------------------------
# Alias
#-------------------------------------------------------------------------------

# Files
# unalias ll
# alias ll='eza -l --icons'
# unalias la
# alias la='eza -la --icons --git'
# alias tree='eza --tree --level=2 --icons'

# Git
# unalias gb
# alias gb='git branch | fzf-tmux -d 15'

# fzf fuzzy finder keybindings
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# zsh-vi-mode breaks fzf keybindings
# see https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
# zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

# starship prompt
eval "$(starship init zsh)"
# fzf
eval "$(fzf --zsh)"
# zoxide
# eval "$(zoxide init zsh)"

