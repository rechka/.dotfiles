#!/bin/bash

#timezone
timedatectl set-timezone America/Toronto

#update repos & upgrade
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y
snap refresh

#all you need
apt-get -y --no-install-recommends install awscli zsh tintin++ ranger python3-venv fluxbox tightvncserver xdg-utils python3-pip \
nodejs gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 fonts-powerline \
libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 git-secret \
libxcursor1 rcm git-secret icdiff libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release libgbm1 xclip xsel fzf ripgrep \
dunst suckless-tools compton hsetroot xsettingsd lxappearance xclip byobu xfonts-base xfonts-100dpi xfonts-75dpi
snap install micro --classic
snap install docker
addgroup --system docker
snap disable docker
snap enable docker

#user
adduser --gecos "" --disabled-password --ingroup ubuntu --shell /usr/bin/zsh --debug --add_extra_groups rechka
passwd -d rechka
usermod -aG sudo rechka
usermod -aG adm rechka
usermod -aG docker rechka

ssh-keyscan github.com >> /tmp/githubKey
ssh-keygen -lf /tmp/githubKey
cat /tmp/githubKey >> /home/ubuntu/.ssh/known_hosts
rm /tmp/githubKey

cp -r /home/ubuntu/.ssh /home/rechka/

chown rechka.ubuntu -R /home/rechka/.ssh
chmod 700 /home/rechka/.ssh
chmod 600 /home/rechka/.ssh/authorized_keys


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
su -c 'cd ~ && curl -fsSL https://code-server.dev/install.sh | sh' rechka
#starship
su -c 'cd ~ && curl -fsSL https://starship.rs/install.sh | bash -s -- --yes' rechka
#zulu 
su -c 'cd ~ && curl -L https://zulu.molovo.co/install | zsh' rechka

#dotfiles
su -c 'cd ~ && git clone https://github.com/rechka/.dotfiles.git && rcup -f rcrc && rcup -f' rechka

su -c 'cd ~ && source ~/.zulu/core/zulu && zulu init && \
zulu install async fast-syntax-highlighting solarized-man z \
zui you-should-use spaceship k enhancd autosuggestions sudo \
completions dwim history-substring-search command-not-found' rechka

#git 
su -c 'cd ~/.dotfiles && git config user.name rechka && git config user.email chto@zachem.ru' rechka

apt-get -y install etckeeper
systemctl start etckeeper.timer
etckeeper vcs gc

#nerdfont
su -c 'mkdir -p ~/.local/share/fonts' rechka
su -c 'cd ~/.local/share/fonts && curl -fLo "Fira Code Retina Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fira%20Code%20Retina%20Nerd%20Font%20Complete%20Mono.ttf' rechka


# cat /var/log/cloud-init-output.log
echo 'alias cv="cat /var/log/cloud-init-output.log"' >> /home/rechka/.zshrc

#gpg install
echo 'alias gpginstall="gpg --import rechka.asc"' >> /home/rechka/.zshrc

#remove myself
rm -rf /var/lib/cloud/instances/i-*/scripts/
rm -f /var/lib/cloud/instances/i-*/user-data.txt*

