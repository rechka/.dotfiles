alias python=python3
alias myip="curl ip.smartproxy.com"
alias l=k
alias ls=k
alias ka="k -A"
alias kk="k -A"
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

alias awsnew="aws ec2 run-instances \
    --image-id ami-08962a4068733a2b6 \
    --instance-type t2.micro \
    --block-device-mappings DeviceName=/dev/sda1,Ebs={VolumeSize=30} \
    --count 1 \
    --key-name termius-rsa \
    --user-data file://aws-init.sh > ~/aws-run.json"
    
alias awsid="cat ~/aws-run.json | jq -r '.Instances[].InstanceId'"

