username=rechka

echo https://dl-cdn.alpinelinux.org/alpine/v3.12/main > /etc/apk/repositories
echo https://dl-cdn.alpinelinux.org/alpine/v3.12/community >> /etc/apk/repositories
echo https://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
apk upgrade -q --progress --update-cache --available

for pkg in git zsh tzdata curl openssh ncurses screen byobu \
 terraform ranger tmux jq rcm gawk sudo neovim git-secret shadow ; do
  apk add -q --progress $pkg
  echo added $pkg
  
  case $pkg in
    tzdata) 
      echo setting timezone
      echo "America/Toronto" >  /etc/timezone
      cp /usr/share/zoneinfo/America/Toronto /etc/localtime
      echo removing $pkg
      apk del -q --progress $pkg

      ;;

    shadow)
      echo creating user ${username}
      adduser -g "" -D -G wheel -s /bin/zsh $username
      echo removing passwords
      passwd -d -q $username
      passwd -d -q root
      echo changing shell
      chsh -s /bin/zsh
      echo removing $pkg
      apk del -q --progress $pkg
      ;;
    sudo)
      echo adding wheel group to sudoers
      sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers
      ;;

  esac
  
done

#user
#echo "login ${username}" > .zshrc

mount -t ios whatever /mnt
su -c "gpg -q --import /mnt/${username}.asc" $username
umount -t ios /mnt

#zulu 
su - -c 'cd ~ && curl -sL https://zulu.molovo.co/install | zsh && \
echo installed zulu && source ~/.zulu/core/zulu && zulu init && \
echo initialized zulu && exit' $username
echo 1111
su - -c 'cd ~ && source ~/.zulu/core/zulu && zulu init && zulu install filthy pure minimal k \
async fast-syntax-highlighting z zui you-should-use k enhancd && exit' $username
echo 2222
su - -c 'cd ~ && source ~/.zulu/core/zulu && zulu init && zulu install autosuggestions completions \
dwim history-substring-search command-not-found && \
echo installed plugins && zulu theme filthy && echo graceful exit && exit' $username

echo 3333

#dotfiles
su -c "cd ~ && git clone -q --depth 1 https://github.com/${username}/.dotfiles.git && rcup -f rcrc" $username
su -c "cd ~/.dotfiles && git secret reveal && rcup -f" $username
chmod 600 /home/$username/.ssh/*
su -c "cd ~/.dotfiles && git config user.name ${username} && git config user.email ${username}@neverho.od" $username
su -c "cd ~/.dotfiles && git remote set-url origin git@github.com:${username}/.dotfiles.git" $username

# 1.13.15 + 2 errors
#curl -fLo /tmp/go1.16.3.linux-amd64.tar.gz https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
#rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go1.16.3.linux-amd64.tar.gz
#rm /tmp/go1.16.3.linux-amd64.tar.gz

# push etckeeper
#sed -i "s/PUSH_REMOTE=\"\"/PUSH_REMOTE=\"origin\"/g" /etc/etckeeper/etckeeper.conf
#cd /etc && git add . && git commit -m "userdata complete" && git push -u origin `git branch --show-current`

#inform about readiness
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"content": "reporting for duty 🪖"}' \
  https://discord.com/api/webhooks/836440229077450753/sZfAjucdHe8dowGU3YHHVVxbS_oExgZOCYFI5TB3srGhmtZpfE0dXwkFq7J8_ZVzddOa

exit
