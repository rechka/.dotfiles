# username
username=rechka

#timezone
apk add tzdata
cp /usr/share/zoneinfo/America/Toronto /etc/localtime
echo "America/Toronto" >  /etc/timezone
apk del tzdata

apk -U upgrade
apk add git zsh gawk gpgme curl bash ripgrep nodejs npm openssh \
 make ranger aws-cli jq rcm rclone fzf sudo

mount -t ios whatever /mnt
gpg --import /mnt/$username.asc
umount -t ios /mnt

#snaps used to be here
curl https://getmic.ro | bash && mv micro /bin
git clone --depth 1 https://github.com/sobolevn/git-secret.git
cd git-secret && make build && PREFIX="/usr/local" make install
cd ~
git clone --depth 5 https://github.com/$username/.dotfiles.git && rcup -f rcrc
cd .dotfiles && git secret reveal && rcup -f

# 1.13.15 + 2 errors
#curl -fLo /tmp/go1.16.3.linux-amd64.tar.gz https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
#rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go1.16.3.linux-amd64.tar.gz
#rm /tmp/go1.16.3.linux-amd64.tar.gz

#suckless

#user
adduser -g "" -D -G adm -s /bin/zsh $username
passwd -d $username
#?usermod -aG sudo $username

#zulu 
su - -c 'curl -L https://zulu.molovo.co/install | zsh' $username

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

# push etckeeper
#sed -i "s/PUSH_REMOTE=\"\"/PUSH_REMOTE=\"origin\"/g" /etc/etckeeper/etckeeper.conf
#cd /etc && git add . && git commit -m "userdata complete" && git push -u origin `git branch --show-current`

#inform about readiness
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"username": "'"$HOSTNAME"'", "content": "'"I live in $PUBLIC_IPV4"'"}' \
  $WEBHOOK_URL 
