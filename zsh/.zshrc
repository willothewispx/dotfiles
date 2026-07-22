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

# Go
export GOROOT=$(brew --prefix go)/libexec
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

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

gcm() {
  if git diff --cached --quiet; then
    echo "No staged changes found."
    return 1
  fi

  {
    echo "Create exactly one conventional commit message for the staged git diff below."
    echo "Return only the commit message text. Do not use markdown, bullets, explanations, or quotes."
    echo
    git diff --cached
  } | fabric-ai -p raw_query -m "gpt-5.4-mini"
}

# Fabric
alias fabric='fabric-ai'

autoload -Uz compinit
compinit

# starship prompt
eval "$(starship init zsh)"
# fzf
eval "$(fzf --zsh)"
# zoxide
eval "$(zoxide init zsh)"
# taskfile
eval "$(task --completion zsh)"

# Plugins
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load
