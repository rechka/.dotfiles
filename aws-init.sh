#!/bin/bash

echo "alias tv='tail -fs1 /var/log/cloud-init-output.log'" >> /root/.bashrc
echo "alias cv='less /var/log/cloud-init-output.log'" >> /root/.bashrc


curl $INFORMER --output /usr/local/sbin/sshd-login && \
  chmod +x /usr/local/sbin/sshd-login && \
  echo "session   optional   pam_exec.so   /usr/local/sbin/sshd-login" >> /etc/pam.d/sshd

# username
username=rechka

#timezone
timedatectl set-timezone America/Toronto

apt-get remove -y --purge man-db

#initialize etckeeper
host=`curl -s ip.smartproxy.com`
apt-get -yqq install etckeeper
cd /etc && git config --system user.name robot && git config --system user.email robot@$host
cd /etc && git config user.name robot && git config user.email robot@$host
systemctl start etckeeper.timer
etckeeper vcs gc
cd /etc && git checkout -b `date +%y%m%d_%H%M` && git remote add origin git@github.com:$username/etc.git

#update repos & upgrade
apt-get -yqq update && TERM=linux DEBIAN_FRONTEND=noninteractive apt-get -yqq -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade && \
apt-get -yqq autoremove && apt-get -yqq clean && apt-get -yqq autoclean

#snaps used to be here
curl https://getmic.ro | bash && mv micro /usr/bin
curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
#curl -fLo /tmp/go1.16.3.linux-amd64.tar.gz https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
#rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go1.16.3.linux-amd64.tar.gz
#rm /tmp/go1.16.3.linux-amd64.tar.gz
# /usr/local/go/bin to PATH

apt-get -yqq --no-install-recommends install awscli zsh tintin++ ranger python3-venv fluxbox tightvncserver xdg-utils python3-pip \
nodejs gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 fonts-powerline jq \
libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 git-secret \
libxcursor1 rcm git-secret icdiff libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release libgbm1 xclip xsel fzf ripgrep \
dunst suckless-tools rclone compton hsetroot xsettingsd lxappearance xclip byobu xfonts-base xfonts-100dpi xfonts-75dpi \
apt-transport-https ca-certificates curl gnupg glances lsb-release nodejs jupyter-core

#docker
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#echo \
#  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#apt-get -yqq update && apt-get -yqq --no-install-recommends install docker-ce docker-ce-cli containerd.io

#user
adduser --gecos "" --disabled-password --ingroup adm --shell /usr/bin/zsh --debug --add_extra_groups $username
passwd -d $username
usermod -aG sudo $username
addgroup --system docker
usermod -aG docker $username
service docker restart

cp -r ~/.ssh /home/$username/
chown $username.adm -R /home/$username/.ssh
chmod 700 /home/$username/.ssh

#chrome 84
#cd /tmp
#wget -q https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/19746659/+files/chromium-browser_84.0.4147.105-0ubuntu0.16.04.1_amd64.deb
#wget -q https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage/+build/19746659/+files/chromium-codecs-ffmpeg_84.0.4147.105-0ubuntu0.16.04.1_amd64.deb
#dpkg -i -E chromium-*.deb
#apt-mark hold chromium-browser
#apt-mark hold chromium-codecs-ffmpeg
#rm chromium-*.deb
#cd /root

su - -c 'curl -fsSL https://linux.kite.com/dls/linux/current | bash -s -- --install silent' $username

#starship
su - -c 'curl -fsSL https://starship.rs/install.sh | bash -s -- --yes' $username
#zulu 
su - -c 'curl -L https://zulu.molovo.co/install | zsh' $username

#dotfiles, watch out for variable in repo url
su - -c "git clone https://github.com/$username/.dotfiles.git && rcup -f rcrc && rcup -f" $username
# add to PATH /home/$username/.local/bin
su - -c 'pip3 -q install -r ~/.dotfiles/requirements.txt' $username

su - -c 'source ~/.zulu/core/zulu && zulu init && \
zulu install async fast-syntax-highlighting solarized-man z \
zui you-should-use spaceship k enhancd autosuggestions sudo \
completions dwim history-substring-search command-not-found' $username

#git 
su -c "cd ~/.dotfiles && git config user.name $username && git config user.email $username@what.if" $username

#nerdfont
#su -c 'mkdir -p ~/.local/share/fonts' $username
#su -c 'cd ~/.local/share/fonts && curl -fLo "Fira Code Retina Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fira%20Code%20Retina%20Nerd%20Font%20Complete%20Mono.ttf' $username

su - -c "echo -e \"$GPG_KEY\" | gpg --import && cd ~/.dotfiles && git secret reveal -f && cd ~ && rcup -vf" $username
chmod 600 /home/$username/.ssh/*
su -c 'ssh -vT git@github.com' $username
su -c "cd ~/.dotfiles && git remote set-url origin git@github.com:$username/.dotfiles.git" $username


#lab
su - -c "echo -e \"$KITE_PASS\" | ~/.local/share/kite/login-user \"$KITE_LOGIN\"" $username
jupyter labextension install jupyterlab-topbar-text --no-build
jupyter labextension install jupyterlab-topbar-extension --no-build
jupyter labextension install jupyterlab-theme-toggle --no-build
jupyter labextension install jupyterlab-spreadsheet --no-build
#jupyter labextension install @datalayer-jupyter/jupyterlab-git
#jupyter labextension install @jupyterlab/shortcutui
#jupyter labextension install @oriolmirosa/jupyterlab_materialdarker
jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
#jupyter labextension install @jupyterlab/google-drive
#jupyter labextension install jupyterlab-flake8
echo "1"
jupyter lab build 
echo "2"
jupyter lab build --dev-build=False --minimize=False 



# push etckeeper
sed -i "s/PUSH_REMOTE=\"\"/PUSH_REMOTE=\"origin\"/g" /etc/etckeeper/etckeeper.conf
cp /home/$username/.ssh/id_rsa* ~/.ssh/
cp /home/$username/.ssh/known_hosts ~/.ssh/
ssh -vT git@github.com
cd /etc && git add . && git commit -m "userdata complete" && git push -u origin `git branch --show-current`

#remove myself
rm -rf /var/lib/cloud/instances/i-*/scripts/
rm -f /var/lib/cloud/instances/i-*/user-data.txt*

export HOSTNAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)
export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)

#inform about readiness
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"username": "'"$HOSTNAME"'", "content": "'"I live in $PUBLIC_IPV4"'"}' \
  $WEBHOOK_URL
  
