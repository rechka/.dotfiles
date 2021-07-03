alias python=python3
alias myip="curl ip.smartproxy.com"
alias ka="k -A"
alias kk="k -A"
alias vncup1="vncserver :0 -depth 24H -geometry 2732x2048"
alias vncup2="vncserver :0 -depth 24H -geometry 1366x1024"
alias terraup="terraform destroy -auto-approve && terraform apply -auto-approve"
alias vncdown="vncserver -kill :0"
alias cv="cat /var/log/cloud-init-output.log"
alias cvg="cat /var/log/cloud-init-output.log | rg -S -C3 fail && cat /var/log/cloud-init-output.log | rg -S -C3 error && cat /var/log/cloud-init-output.log | rg -S -C3 warning && cat /var/log/cloud-init-output.log | rg -S -C3 outdated"
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
#source "${ZULU_DIR:-"${ZDOTDIR:-$HOME}/.zulu"}/core/zulu"
#zulu init

path+=('/usr/local/go/bin')
path+=($PWD/.local/bin)
export PATH
export EDITOR=micro

# Created by `pipx` on 2021-06-06 18:05:21
export PATH="$PATH:/home/rechka/.local/bin"

autoload -U +X bashcompinit && bashcompinit
#complete -o nospace -C /usr/local/bin/terraform terraform

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone --depth 1 https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Plugin history-search-multi-word loaded with investigating.
zinit ice depth=1; zinit load zdharma/history-search-multi-word
zinit ice depth=1; zinit load supercrabtree/k

# Two regular plugins loaded without investigating.
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
zinit ice depth=1; zinit light zdharma/fast-syntax-highlighting

# Snippet
zinit ice depth=1; zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/

# Load starship theme
zinit ice depth'1' as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh" # pull behavior same as clone, source init.zsh
zinit ice depth=1; zinit light starship/starship

zinit ice depth=1 as"completion"
zinit snippet OMZ::plugins/ripgrep/_ripgrep

zinit ice depth=1
zinit snippet 'https://github.com/timothyrowan/betterbrew-zsh-plugin/raw/master/betterbrew.plugin.zsh'

zinit ice depth=1
zinit snippet 'https://github.com/Tarrasch/zsh-command-not-found/raw/master/command-not-found.plugin.zsh'

zinit ice pick'init.zsh' blockf
zinit light laggardkernel/git-ignore
alias gi="git-ignore"

zinit ice depth=1
zinit load peterhurford/git-it-on.zsh
zinit ice depth=1
zinit load rapgenic/zsh-git-complete-urls
#zplug "b4b4r07/enhancd", use:init.sh
zinit ice depth=1
zinit load "MichaelAquilina/zsh-autoswitch-virtualenv"

zinit ice depth=1
zinit snippet hzsh-users/zsh-apple-touchbar

zinit ice depth=1
zinit load iam4x/zsh-iterm-touchbar


zinit ice pick'init.zsh' compile'*.zsh' depth'1'
zinit light laggardkernel/zsh-iterm2
