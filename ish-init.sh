# username
username=rechka

#timezone
apk add tzdata
cp /usr/share/zoneinfo/America/Toronto /etc/localtime
echo "America/Toronto" >  /etc/timezone
apk del tzdata

apk -U upgrade
apk add git zsh gawk gpgme curl bash ripgrep nodejs npm openssh \
 make go ranger aws-cli jq rcm xclip rclone byobu

#snaps used to be here
curl https://getmic.ro | bash && mv micro /usr/bin
git clone --depth 1 https://github.com/sobolevn/git-secret.git
cd git-secret && make build && PREFIX="/usr/local" make install

# 1.13.15 + 2 errors
#curl -fLo /tmp/go1.16.3.linux-amd64.tar.gz https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
#rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go1.16.3.linux-amd64.tar.gz
#rm /tmp/go1.16.3.linux-amd64.tar.gz

glances suckless fzf

#user
adduser --gecos "" --disabled-password --ingroup adm --shell /usr/bin/zsh --debug --add_extra_groups $username
passwd -d $username
usermod -aG sudo $username
#addgroup --system docker
#usermod -aG docker $username
#service docker restart

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

#zulu 
su - -c 'curl -L https://zulu.molovo.co/install | zsh' $username

#dotfiles, watch out for variable in repo url
su - -c "git clone https://github.com/$username/.dotfiles.git && rcup -f rcrc && rcup -f" $username
#su - -c 'pip3 install -U --no-warn-script-location -r ~/.dotfiles/requirements.txt' $username

su - -c 'source ~/.zulu/core/zulu && zulu init && \
zulu install async fast-syntax-highlighting z \
zui you-should-use pure minimal k enhancd autosuggestions sudo \
completions dwim history-substring-search command-not-found && \
zulu theme pure && zulu theme minimal' $username

#git 
su - -c "cd ~/.dotfiles && git config user.name $username && git config user.email $username@$HOSTNAME" $username

#nerdfont
#su -c 'mkdir -p ~/.local/share/fonts' $username
#su -c 'cd ~/.local/share/fonts && curl -fLo "Fira Code Retina Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fira%20Code%20Retina%20Nerd%20Font%20Complete%20Mono.ttf' $username

su - -c "echo -e \"$GPG_KEY\" | gpg --import && cd ~/.dotfiles && git secret reveal -f && cd ~ && rcup -vf" $username
chmod 600 /home/$username/.ssh/*
#su - -c 'ssh -vT git@github.com' $username
cp /home/$username/.ssh/id_rsa* ~/.ssh/
cp /home/$username/.ssh/known_hosts ~/.ssh/
#ssh -vT git@github.com
su - -c "cd ~/.dotfiles && git remote set-url origin git@github.com:$username/.dotfiles.git" $username


#lab
#su - -c 'PATH=~/.local/bin:$PATH jupyter labextension install jupyterlab-topbar-text --no-build' $username
#su - -c 'PATH=~/.local/bin:$PATH jupyter labextension install jupyterlab-topbar-extension --no-build' $username
#su - -c 'PATH=~/.local/bin:$PATH jupyter labextension install jupyterlab-theme-toggle --no-build' $username
#su - -c 'PATH=~/.local/bin:$PATH jupyter labextension install jupyterlab-spreadsheet --no-build' $username
#su - -c 'PATH=~/.local/bin:$PATH jupyter labextension install @jupyterlab/debugger --no-build' $username
#su - -c 'PATH=~/.local/bin:$PATH jupyter labextension uninstall nbdime-jupyterlab --no-build' $username
#su - -c 'PATH=~/.local/bin:$PATH jupyter contrib nbextension install --user' $username
#jupyter labextension install @datalayer-jupyter/jupyterlab-git
#jupyter labextension install @jupyterlab/shortcutui
#jupyter labextension install @oriolmirosa/jupyterlab_materialdarker
#su - -c 'PATH=~/.local/bin:$PATH jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build' $username
#jupyter labextension install @jupyterlab/google-drive
#jupyter labextension install jupyterlab-flake8
#su - -c 'PATH=~/.local/bin:$PATH jupyter lab build' $username

snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
#certbot certonly --standalone -m $EMAIL --agree-tos --domains $DOMAIN -n
git clone git@github.com:rechka/lec.git /etc/letsencrypt
certbot certificates
setfacl -R -m u:$username:rX /etc/letsencrypt/{live,archive}/$DOMAIN
setfacl -m u:$username:rX /etc/letsencrypt/{live,archive}
su - -c 'ln -s /etc/letsencrypt/live/'"'$DOMAIN'"'/fullchain.pem /home/'"'$username'"'/.jupyter/.cert' $username
su - -c 'ln -s /etc/letsencrypt/live/'"'$DOMAIN'"'/privkey.pem /home/'"'$username'"'/.jupyter/.key' $username

#source https://gist.github.com/danibram/d00ed812f2ca6a68758e
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8443
iptables -t nat -A OUTPUT -o lo -p tcp --dport 443 -j REDIRECT --to-port 8443
sh -c "iptables-save > /etc/iptables.rules"

#source https://gist.github.com/alonisser/a2c19f5362c2091ac1e7
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
apt-get -y install iptables-persistent

# push etckeeper
#sed -i "s/PUSH_REMOTE=\"\"/PUSH_REMOTE=\"origin\"/g" /etc/etckeeper/etckeeper.conf
#cd /etc && git add . && git commit -m "userdata complete" && git push -u origin `git branch --show-current`

#remove myself
rm -rf /var/lib/cloud/instances/i-*/scripts/
rm -f /var/lib/cloud/instances/i-*/user-data.txt*




#inform about readiness
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"username": "'"$HOSTNAME"'", "content": "'"I live in $PUBLIC_IPV4"'"}' \
  $WEBHOOK_URL
  
