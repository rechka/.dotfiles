# username
username=rechka

#timezone
apk add tzdata
cp /usr/share/zoneinfo/America/Toronto /etc/localtime
echo "America/Toronto" >  /etc/timezone
apk del tzdata

echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk upgrade --update-cache --available
apk add git zsh gawk gpgme curl bash ripgrep nodejs npm openssh \
 make ranger aws-cli jq rcm rclone fzf sudo nano git-secret@testing micro

#user
adduser -g "" -D -G wheel -s /bin/zsh $username
passwd -d $username
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers

mount -t ios whatever /mnt
gpg --import /mnt/$username.asc
umount -t ios /mnt

#dotfiles
git clone --depth 5 https://github.com/$username/.dotfiles.git && rcup -f rcrc
cd .dotfiles && git secret reveal && rcup -f

# 1.13.15 + 2 errors
#curl -fLo /tmp/go1.16.3.linux-amd64.tar.gz https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
#rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go1.16.3.linux-amd64.tar.gz
#rm /tmp/go1.16.3.linux-amd64.tar.gz

#suckless - need to figues out x11+vnc first, maybe novnc?

#zulu 
su - -c 'curl -L https://zulu.molovo.co/install | zsh' $username
su - -c 'source ~/.zulu/core/zulu && zulu init && \
zulu install async fast-syntax-highlighting z \
zui you-should-use pure minimal k enhancd autosuggestions sudo \
completions dwim history-substring-search command-not-found && \
zulu theme pure && zulu theme minimal' $username

#git 
cd ~/.dotfiles && git config user.name $username && git config user.email $username@$HOSTNAME
echo -e \"$GPG_KEY\" | gpg --import && cd ~/.dotfiles && git secret reveal -f && cd ~ && rcup -vf
chmod 600 /home/$username/.ssh/*
cd ~/.dotfiles && git remote set-url origin git@github.com:$username/.dotfiles.git

# push etckeeper
#sed -i "s/PUSH_REMOTE=\"\"/PUSH_REMOTE=\"origin\"/g" /etc/etckeeper/etckeeper.conf
#cd /etc && git add . && git commit -m "userdata complete" && git push -u origin `git branch --show-current`

#inform about readiness
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"username": "'"$HOSTNAME"'", "content": "'"I live in $PUBLIC_IPV4"'"}' \
  $WEBHOOK_URL 
