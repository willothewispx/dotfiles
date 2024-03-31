#  ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗    ███████╗███████╗██╗  ██╗
# ██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝    ╚══███╔╝██╔════╝██║  ██║
# ██║   ██║███████║    ██╔████╔██║ ╚████╔╝       ███╔╝ ███████╗███████║
# ██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝       ███╔╝  ╚════██║██╔══██║
# ╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║       ███████╗███████║██║  ██║
#  ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝

################################################################################
# Exports
################################################################################

# PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/opt/homebrew/bin:$PATH

# Editor
export EDITOR="nvim"

#-------------------------------------------------------------------------------
# Alias
#-------------------------------------------------------------------------------

# Files
unalias ll
# alias ll='eza -l --icons'
unalias la
alias la='eza -la --icons --git'
alias tree='eza --tree --level=2 --icons'

# Git
unalias gb
alias gb='git branch | fzf-tmux -d 15'

# starship prompt
eval "$(starship init zsh)"
# fzf
eval "$(fzf --zsh)"
# zoxide
eval "$(zoxide init zsh)"
