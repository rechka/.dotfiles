grep -v "file:///ish/apk/" /etc/apk/repositories | dd of=/etc/apk/repositories bs=4194304
echo https://dl-cdn.alpinelinux.org/alpine/v3.12/main >> /etc/apk/repositories
echo https://dl-cdn.alpinelinux.org/alpine/v3.12/community >> /etc/apk/repositories
echo "@micro https://dl-cdn.alpinelinux.org/alpine/v3.13/community" >> /etc/apk/repositories
echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk upgrade --update-cache --available
apk add git zsh tzdata curl openssh tmux screen byobu \
 ranger jq rcm gawk sudo neovim git-secret@testing micro@micro

cp /usr/share/zoneinfo/America/Toronto /etc/localtime
apk del tzdata
echo "America/Toronto" >  /etc/timezone

#root
apk add shadow
passwd -d root
chsh -s /bin/zsh
apk del shadow

# username
username=rechka

#user
adduser -g "" -D -G wheel -s /bin/zsh $username
passwd -d $username
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
echo "login ${username}" > .zshrc

mount -t ios whatever /mnt
su -c "gpg --import /mnt/${username}.asc" $username
umount -t ios /mnt

#dotfiles
su -c "cd ~ && git clone --depth 5 https://github.com/${username}/.dotfiles.git && rcup -f rcrc" $username
su -c "cd ~/.dotfiles && git secret reveal && rcup -f" $username
chmod 600 /home/$username/.ssh/*
su -c "cd ~/.dotfiles && git config user.name ${username} && git config user.email ${username}@neverho.od" $username
su -c "cd ~/.dotfiles && git remote set-url origin git@github.com:${username}/.dotfiles.git" $username

# 1.13.15 + 2 errors
#curl -fLo /tmp/go1.16.3.linux-amd64.tar.gz https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
#rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go1.16.3.linux-amd64.tar.gz
#rm /tmp/go1.16.3.linux-amd64.tar.gz

#suckless - need to figues out x11+vnc first, maybe novnc?

#zulu 
#su - -c 'curl -L https://zulu.molovo.co/install | zsh' $username
#su - -c 'source ~/.zulu/core/zulu && zulu init && \
#zulu install async fast-syntax-highlighting z \
#zui you-should-use pure minimal k enhancd autosuggestions sudo \
#completions dwim history-substring-search command-not-found && \
#zulu theme pure && zulu theme minimal' $username


# push etckeeper
#sed -i "s/PUSH_REMOTE=\"\"/PUSH_REMOTE=\"origin\"/g" /etc/etckeeper/etckeeper.conf
#cd /etc && git add . && git commit -m "userdata complete" && git push -u origin `git branch --show-current`

#inform about readiness
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"content": "reporting for duty 🪖"}' \
  https://discord.com/api/webhooks/836440229077450753/sZfAjucdHe8dowGU3YHHVVxbS_oExgZOCYFI5TB3srGhmtZpfE0dXwkFq7J8_ZVzddOa

exit
