alias python=python3
alias myip="curl ip.smartproxy.com"
alias ka="k -A"
alias kk="k -A"
alias vncup1="vncserver :0 -depth 24H -geometry 2732x2048"
alias vncup2="vncserver :0 -depth 24H -geometry 1366x1024"
alias jlabup="jupyter lab --ip=`echo $(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/anchor_ipv4/address)`"
alias vncdown="vncserver -kill :0"
alias cv="cat /var/log/cloud-init-output.log"
alias cvg="cat /var/log/cloud-init-output.log | rg -S -A3 -B3 fail && cat /var/log/cloud-init-output.log | rg -S -A3 -B3 error && cat /var/log/cloud-init-output.log | rg -S -A3 -B3 warning && cat /var/log/cloud-init-output.log | rg -S -A3 -B3 outdated"
alias gitsshclone='f() { git clone git@github.com:$1.git };f'

export DISPLAY=:0
HISTFILE=~/.histfile
HISTSIZE=15000
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_EXIT_CODE_SYMBOL=""
SAVEHIST=15000
SPACESHIP_TIME_SHOW=true
setopt autocd extendedglob notify
bindkey -e

# Initialise zulu plugin manager
source "${ZULU_DIR:-"${ZDOTDIR:-$HOME}/.zulu"}/core/zulu"
zulu init

eval "$(starship init zsh)"

path+=('/usr/local/go/bin')
path+=($PWD/.local/bin)
export PATH
