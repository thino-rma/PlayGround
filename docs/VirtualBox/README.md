### VirtualBox
### CentOS8へのインストール
- how to install
  - VirtualBox
    ```console
    $ sudo su -
    # yum install elfutils-libelf-devel
    ### 初回は生成は成功するが、起動は失敗する？
    # /sbin/vboxconfig
    ### エラーメッセージがこちら。
    ### vboxdrv.sh: failed: modprobe vboxdrv failed. Please use 'dmesg' to find out why.
    ### そして、dmesgのメッセージがこちら。
    ### [  464.090443] Lockdown: modprobe: Loading of untrusted modules is restricted; see man kernel_lockdown.7
    ### 生成されたものがこちら。
    # ls -alF $(dirname $(modinfo -n vboxdrv))/
    ### これらのファイルを署名する必要がある。

    # sudo dnf -y update
    # sudo dnf -y install mokutil
    # sudo -i
    # mkdir /root/signed-modules
    ### 以下のコマンドで、キーを生成する。CNをVirtualBoxにしている。daysは100年弱とした。
    # openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VirtualBox/"
    # chmod 600 MOK.priv
    # mokutil --import MOK.der
    ### >>> input password: 1qaz..

    # cd /root/signed-modules
    # vi sign-virtual-box

    ### 中身はこちら。
    # cat sign-virtual-box
    #!/bin/bash
     
    for modfile in $(dirname $(modinfo -n vboxdrv))/*.ko; do
      echo "Signing $modfile"
      /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 \
                                    /root/signed-modules/MOK.priv \
                                    /root/signed-modules/MOK.der "$modfile"
    done
    ### ---

    # chmod 700 sign-virtual-box
    ### 実行して署名する
    # ./sign-virtual-box

    # shutdown -h  (don't reboot)
    ### step into BIOS, select key, input password, and reboot.
    
    ### after reboot
    $ sudo su -
    # modprobe vboxdrv
    ```
