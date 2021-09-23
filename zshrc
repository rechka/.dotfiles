zstyle ':completion:*' '' matcher-list 'm:{a-z}={A-Z}'

flush() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
}

dumpapk() {
    apks=("${(@f)$(adb -s $1 shell pm path $2 | sed s/package://g)}")
    mkdir $2
    for apk in $apks; do
        adb -s $1 pull $apk $2
    done;
}

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
alias adbreboot='f() { adb -s $1 shell reboot };f'
alias pomigat='f() { adbpower $1 & adbpower $1 & adbpower $1 & adbpower $1  };f'
alias adbpower='f() { adb -s $1 shell input keyevent 26 };f'

alias control='f() { scrcpy --forward-all-clicks -Sw -s $1 -b 2M --max-fps 10 -m 1000 --window-title $1 -t -p 27180:27200 };f'


mssh2() {
    pssh -h ~/Documents/hosts.txt -t 0 -l rechka -i \("$@"\)
}

adbnames() {
    curl -s "https://api.airtable.com/v0/<app>/phones" \
      -H "Authorization: Bearer <key>" | jq -c -r  '.records[].fields | {serial, location, sticker}' | tr -d '{}"' | sed 's/serial://g' | sed 's/,location:/ /g' | sed 's/,sticker://g' | awk '{print $1" "$2}' > mapping.txt
    adb devices | awk 'NR>1 && NF' > data.txt
    print SERVER: `hostname` \(TOTAL: `cat data.txt | wc -l`\)
    awk 'NR == FNR{a[$1]=$2;next} {$1=a[$1]" ("$1")"}1' mapping.txt data.txt > output.txt
    sort -t\n output.txt
}

get_phones() {
    phones=("${(@f)$(adb devices | awk 'NR>1 {print $1;}')}")
}


zeroprep() {
    cd /Volumes/boot
    git init
    git remote add origin https://github.com/rechka/dietzerow.git
    git fetch origin
    git reset --hard FETCH_HEAD
    sed -i -e "s/zerotest1/top/g" dietpi.txt
}
pi4prep() {
    cd /Volumes/boot
    git init
    git remote add origin https://github.com/rechka/diet4b.git
    git fetch origin
    git reset --hard FETCH_HEAD
    sed -i -e "s/dietX/raspi4/g" dietpi.txt
}



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
path+=('/usr/local/bin')
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
#zinit ice depth'1' as"command" from"gh-r" \
#    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
#    atpull"%atclone" src"init.zsh" # pull behavior same as clone, source init.zsh
#zinit ice depth=1; zinit light starship/starship

zinit ice depth=1 as"completion"
zinit snippet OMZ::plugins/ripgrep/_ripgrep

zinit ice depth=1
zinit load eventi/noreallyjustfuckingstopalready

if [[ `uname` == "Darwin" ]]; then
    zinit ice depth=1
    zinit load hadenlabs/zsh-core
    zinit ice depth"1"
    zinit load unixorn/tumult.plugin.zsh
    zinit ice pick'init.zsh' compile'*.zsh' depth'1'
    zinit light laggardkernel/zsh-iterm2
    zinit ice depth=1
    zinit load zsh-users/zsh-apple-touchbar
    zinit ice depth=1
    zinit load iam4x/zsh-iterm-touchbar
    zinit snippet 'https://github.com/timothyrowan/betterbrew-zsh-plugin/raw/master/betterbrew.plugin.zsh'
    zinit ice depth'1'
    zinit load vasyharan/zsh-brew-services
	zinit ice depth=1 
	zinit load luismayta/zsh-notify

fi



zinit ice depth=1
zinit load lukechilds/zsh-better-npm-completion

zinit ice as"command" depth=1
zinit load "molovo/revolver"

zinit ice depth=1
zinit load "darvid/zsh-poetry"


zinit ice as"completion"
zinit snippet https://github.com/thuandt/zsh-pipx/raw/master/zsh-pipx.plugin.zsh

zinit snippet 'https://github.com/Tarrasch/zsh-command-not-found/raw/master/command-not-found.plugin.zsh'
zinit snippet https://github.com/wuotr/zsh-plugin-vscode/raw/master/vscode.plugin.zsh
zinit snippet https://github.com/hcgraf/zsh-sudo/raw/master/sudo.plugin.zsh
zinit snippet https://github.com/anatolykopyl/sshukh/raw/master/sshukh.plugin.zsh
alias ssh="sshukh"


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



zinit ice depth'1'
zinit load gko/ssh-connect

zinit ice depth'1'
zinit load aubreypwd/zsh-plugin-reload

zinit ice depth=1; zinit light spaceship-prompt/spaceship-prompt

if ! [[ -z $HOME/.pyenv ]];; then
  curl https://pyenv.run | bash
fi

export PATH="$PATH:$HOME/.local/bin"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
