#  ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗    ███████╗███████╗██╗  ██╗
# ██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝    ╚══███╔╝██╔════╝██║  ██║
# ██║   ██║███████║    ██╔████╔██║ ╚████╔╝       ███╔╝ ███████╗███████║
# ██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝       ███╔╝  ╚════██║██╔══██║
# ╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║       ███████╗███████║██║  ██║
#  ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ssh-agent autostart
if  [[ "$OSTYPE" == "linux-gnu"* ]]; then
	if ! pgrep -u "$USER" ssh-agent > /dev/null; then
			ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
	fi
	if [[ ! "$SSH_AUTH_SOCK" ]]; then
			source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
	fi
fi

################################################################################
# Exports
################################################################################

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# PATH
if  [[ "$OSTYPE" == "darwin"* ]]; then
	export PATH=/usr/local/bin:/usr/local/sbin:$PATH
else
	export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
fi

# gopls
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# npm global
export PATH=$HOME/.npm-global/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Dotfiles
export DOTFILES="$HOME/.dotfiles"
export STOW_DIR=$DOTFILES

if  [[ "$OSTYPE" == "darwin"* ]]; then
	export STOW_FOLDERS="alacritty,kitty-mac,nvim,zsh"
else
  export STOW_FOLDERS="alacritty,awesome,i3,kitty-arch,nvim,polybar,tmux,zathura,zsh"
fi

################################################################################
# Custom Commands
################################################################################

#-------------------------------------------------------------------------------
# Theme
#-------------------------------------------------------------------------------

# powerlevel10k
if  [[ "$OSTYPE" == "darwin"* ]]; then
	ZSH_THEME="powerlevel10k/powerlevel10k"
else
	source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi

################################################################################
# END Custom Comands
################################################################################

plugins=(docker docker-compose git zsh-vi-mode zsh-autosuggestions fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

#-------------------------------------------------------------------------------
# Alias
#-------------------------------------------------------------------------------

# Files
unalias ll
alias ll='exa -l --icons'
unalias la
alias la='exa -la --icons'
alias tree='exa --tree --level=2 --icons'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf fuzzy finder keybindings
if  [[ "$OSTYPE" == "darwin"* ]]; then
	[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  # zsh-vi-mode breaks fzf keybindings
  # see https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
  zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')
else
	source /usr/share/fzf/key-bindings.zsh
	source /usr/share/fzf/completion.zsh
  zvm_after_init_commands+=('source /usr/share/fzf/key-bindings.zsh')
  zvm_after_init_commands+=('source /usr/share/fzf/completion.zsh')
fi

