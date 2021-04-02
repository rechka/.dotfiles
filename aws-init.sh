#!/bin/bash

# username
username=rechka

#timezone
timedatectl set-timezone America/Toronto

#update repos & upgrade
apt-get -qq update -y && TERM=linux DEBIAN_FRONTEND=noninteractive apt-get -yq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade && apt -yqq autoremove && apt -yqq clean && apt -yqq autoclean

apt-get -yqq --no-install-recommends install awscli zsh tintin++ ranger python3-venv fluxbox tightvncserver xdg-utils python3-pip \
nodejs gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 glances libdbus-1-3 fonts-powerline jq \
libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 git-secret \
libxcursor1 rcm git-secret icdiff libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release libgbm1 xclip xsel fzf ripgrep \
dunst suckless-tools rclone compton hsetroot xsettingsd lxappearance xclip byobu xfonts-base xfonts-100dpi xfonts-75dpi

#snaps
snap refresh && snap install docker glances && addgroup --system docker && snap disable docker && snap enable docker
snap install micro --classic
snap install go --classic

#user
adduser --gecos "" --disabled-password --ingroup adm --shell /usr/bin/zsh --debug --add_extra_groups $username
passwd -d $username
usermod -aG sudo $username
usermod -aG docker $username

ssh-keyscan github.com >> /tmp/githubKey
ssh-keygen -lf /tmp/githubKey
cat /tmp/githubKey >> ~/.ssh/known_hosts
rm /tmp/githubKey

cp -r ~/.ssh /home/$username/
chown $username.adm -R /home/$username/.ssh
chmod 700 /home/$username/.ssh

#chrome 84
cd /tmp
wget -q https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/19746659/+files/chromium-browser_84.0.4147.105-0ubuntu0.16.04.1_amd64.deb
wget -q https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/19746659/+files/chromium-codecs-ffmpeg_84.0.4147.105-0ubuntu0.16.04.1_amd64.deb
dpkg -i chromium-*.deb
apt-mark hold chromium-browser
apt-mark hold chromium-codecs-ffmpeg
rm chromium-*.deb
cd /root

#code-server
su - -c 'curl -fsSL https://code-server.dev/install.sh | sh' $username
#fix from https://github.com/cdr/code-server/issues/2975
sed -i "s/req.headers\[\"sec-websocket-extensions\"\]/false/g" \
    /usr/lib/code-server/out/node/routes/vscode.js
sed -i "s/responseHeaders.push(\"Sec-WebSocket-Extensions/\/\/responseHeaders.push(\"Sec-WebSocket-Extensions/g" \
    /usr/lib/code-server/out/node/routes/vscode.js
su -c 'code-server --install-extension ms-python.python --force && \
    code-server --install-extension donjayamanne.githistory --force && \
    code-server --install-extension formulahendry.code-runner --force && \
    code-server --install-extension almenon.arepl --force && \
    code-server --install-extension kiteco.kite --force && \
    code-server --install-extension golang.go --force && \
    code-server --install-extension Shan.code-settings-sync --force && \
    code-server --install-extension humao.rest-client --force && \
    code-server --install-extension ryu1kn.partial-diff --force && \
    code-server --install-extension ms-azuretools.vscode-docker --force' $username
su - -c 'curl -fsSL https://linux.kite.com/dls/linux/current | bash -s -- --install silent' $username

#starship
su - -c 'curl -fsSL https://starship.rs/install.sh | bash -s -- --yes' $username
#zulu 
su - -c 'curl -L https://zulu.molovo.co/install | zsh' $username

#dotfiles
su - -c 'git clone https://github.com/rechka/.dotfiles.git && rcup -f rcrc && rcup -f' $username
su - -c 'pip3 install -r ~/.dotfiles/requirements.txt' $username

su - -c 'source ~/.zulu/core/zulu && zulu init && \
zulu install async fast-syntax-highlighting solarized-man z \
zui you-should-use spaceship k enhancd autosuggestions sudo \
completions dwim history-substring-search command-not-found' $username

#git 
su -c 'cd ~/.dotfiles && git config user.name rechka && git config user.email chto@zachem.ru' $username

apt-get -y install etckeeper
systemctl start etckeeper.timer
etckeeper vcs gc

#nerdfont
su -c 'mkdir -p ~/.local/share/fonts' $username
su -c 'cd ~/.local/share/fonts && curl -fLo "Fira Code Retina Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fira%20Code%20Retina%20Nerd%20Font%20Complete%20Mono.ttf' $username

su - -c "echo -e $GPG_KEY | gpg --import && cd ~/.dotfiles && git secret reveal -f && cd ~ && rcup -vf" $username
ls -la /home/$username/.ssh/* > /home/$username/chmod.log
chmod 600 /home/$username/.ssh/*
ls -la /home/$username/.ssh/* >> /home/$username/chmod.log
su -c 'ssh -vT git@github.com' $username
su -c 'cd ~/.dotfiles && git remote set-url origin git@github.com:rechka/.dotfiles.git' $username

#remove myself
rm -rf /var/lib/cloud/instances/i-*/scripts/
rm -f /var/lib/cloud/instances/i-*/user-data.txt*

echo "alias tv='tail -fs1 /var/log/cloud-init-output.log'" >> /root/.bashrc
echo "alias cv='less /var/log/cloud-init-output.log'" >> /root/.bashrc
