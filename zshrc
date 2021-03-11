alias python=python3
alias myip="curl ip.smartproxy.com"
alias l=k
alias ka="k -A"
alias la="k -A"
alias ll="k -A"
alias ls=k
export DISPLAY=:0
HISTFILE=~/.histfile
HISTSIZE=5000
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_EXIT_CODE_SYMBOL=""
SAVEHIST=5000
SPACESHIP_TIME_SHOW=true
setopt autocd extendedglob notify
bindkey -e

# Initialise zulu plugin manager
source "${ZULU_DIR:-"${ZDOTDIR:-$HOME}/.zulu"}/core/zulu"
zulu init

eval "$(starship init zsh)"
