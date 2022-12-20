# git bashの利用
- Windowsにterminalをインストールする
- Windowsにgit bashをインストールする
- 以下の手順で、tmuxを使えるようにする
  git bashでclone
  ```
  git clone --depth=1 https://github.com/git-for-windows/git-sdk-64 gfw-sdk
  ```
- git bashを管理者で起動し、tmuxをインストールする
  ```
  cp gfw-sdk/usr/bin/pacman* /usr/bin/
  cp -a gfw-sdk/etc/pacman.* /etc/
  mkdir -p /var/lib/
  cp -a gfw-sdk/var/lib/pacman /var/lib/
  cp -a gfw-sdk/usr/share/makepkg/util* /usr/share/makepkg/
  
  pacman --database --check
  
  curl -L https://raw.githubusercontent.com/git-for-windows/build-extra/master/git-for-windows-keyring/git-for-windows.gpg \
  | pacman-key --add - \
  && pacman-key --lsign-key 1A9F3986
  
  pacman -S util-linux
  pacman -S tmux
  ```
- tmuxの起動が失敗する場合は、以下で頑張る
  ```
  cat <<EOF >> ~/.bashrc
  tmux() {
      script -c "tmux" /dev/null
  }
  EOF
  ```
- 同様に、任意のパッケージを追加できます。（git bashを管理者で起動のこと）
  ```
  pacman -S python3 python3-pip
  ```
- 検索は以下のようにする
  ```
  pacman -Ss rsync
  ```
- update and upgrade
  ```
  pacman -Syy   # update only
  pacman -Syyu  # update & upgrade
  ```
