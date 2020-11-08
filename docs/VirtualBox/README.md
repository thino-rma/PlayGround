### VirtualBox
### CentOS8へのインストール
- how to install
  - ssh接続環境（略）
  - SELinuxを解除（略）
  - ファイアウォールを停止（略）
  - リモートデスクトップ環境
  
  - xrdpのカスタマイズ
    - xrdp.iniの修正と画像の配置 https://github.com/xtremeperf/xrdp-modern-login/blob/master/etc/xrdp/xrdp.ini
      修正結果
      ```console
      # cat /etc/xrdp/xrdp.ini
      [Globals]
      ; xrdp.ini file version number
      ini_version=1
      
      ; fork a new process for each incoming connection
      fork=true
      
      ; ports to listen on, number alone means listen on all interfaces
      ; 0.0.0.0 or :: if ipv6 is configured
      ; space between multiple occurrences
      ;
      ; Examples:
      ;   port=3389
      ;   port=unix://./tmp/xrdp.socket
      ;   port=tcp://.:3389                           127.0.0.1:3389
      ;   port=tcp://:3389                            *:3389
      ;   port=tcp://<any ipv4 format addr>:3389      192.168.1.1:3389
      ;   port=tcp6://.:3389                          ::1:3389
      ;   port=tcp6://:3389                           *:3389
      ;   port=tcp6://{<any ipv6 format addr>}:3389   {FC00:0:0:0:0:0:0:1}:3389
      ;   port=vsock://<cid>:<port>
      port=3389
      
      ; 'port' above should be connected to with vsock instead of tcp
      ; use this only with number alone in port above
      ; prefer use vsock://<cid>:<port> above
      use_vsock=false
      
      ; regulate if the listening socket use socket option tcp_nodelay
      ; no buffering will be performed in the TCP stack
      tcp_nodelay=true
      
      ; regulate if the listening socket use socket option keepalive
      ; if the network connection disappear without close messages the connection will be closed
      tcp_keepalive=true
      
      ; set tcp send/recv buffer (for experts)
      #tcp_send_buffer_bytes=32768
      #tcp_recv_buffer_bytes=32768
      
      ; security layer can be 'tls', 'rdp' or 'negotiate'
      ; for client compatible layer
      security_layer=negotiate
      
      ; minimum security level allowed for client for classic RDP encryption
      ; use tls_ciphers to configure TLS encryption
      ; can be 'none', 'low', 'medium', 'high', 'fips'
      crypt_level=high
      
      ; X.509 certificate and private key
      ; openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365
      certificate=
      key_file=
      
      ; set SSL protocols
      ; can be comma separated list of 'SSLv3', 'TLSv1', 'TLSv1.1', 'TLSv1.2', 'TLSv1.3'
      ssl_protocols=TLSv1.2, TLSv1.3
      ; set TLS cipher suites
      #tls_ciphers=HIGH
      
      ; Section name to use for automatic login if the client sends username
      ; and password. If empty, the domain name sent by the client is used.
      ; If empty and no domain name is given, the first suitable section in
      ; this file will be used.
      autorun=
      
      allow_channels=true
      allow_multimon=true
      bitmap_cache=true
      bitmap_compression=true
      bulk_compression=true
      #hidelogwindow=true
      max_bpp=32
      new_cursors=true
      ; fastpath - can be 'input', 'output', 'both', 'none'
      use_fastpath=both
      ; when true, userid/password *must* be passed on cmd line
      #require_credentials=true
      ; You can set the PAM error text in a gateway setup (MAX 256 chars)
      #pamerrortxt=change your password according to policy at http://url
      
      ;
      ; colors used by windows in RGB format
      ;
      blue=009cb5
      grey=dedede
      #black=000000
      #dark_grey=808080
      #blue=08246b
      #dark_blue=08246b
      #white=ffffff
      #red=ff0000
      #green=00ff00
      #background=626c72
      ;
      ; OVERRIDES
      ;
      blue=474740
      dark_blue=08246b
      
      ;
      ; configure login screen
      ;
      
      ; Login Screen Window Title
      #ls_title=My Login Title
      
      ; top level window background color in RGB format
      ls_top_window_bg_color=009cb5
      ls_top_window_bg_color=202020
      
      ; width and height of login screen
      ls_width=350
      ls_height=430
      ls_height=400
      
      ; login screen background color in RGB format
      ls_bg_color=dedede
      ls_bg_color=e8e8e8
      
      ; optional background image filename (bmp format).
      #ls_background_image=
      
      ; logo
      ; full path to bmp-file or file in shared folder
      ls_logo_filename=
      ls_logo_filename=/usr/share/xrdp/login-user.bmp
      ls_logo_x_pos=55
      ls_logo_x_pos=110
      ls_logo_y_pos=50
      
      ; for positioning labels such as username, password etc
      ls_label_x_pos=30
      ls_label_width=65
      
      ; for positioning text and combo boxes next to above labels
      ls_input_x_pos=110
      ls_input_width=210
      
      ; y pos for first label and combo box
      ls_input_y_pos=220
      
      ; OK button
      ls_btn_ok_x_pos=142
      ls_btn_ok_y_pos=370
      ls_btn_ok_y_pos=340
      ls_btn_ok_width=85
      ls_btn_ok_height=30
      
      ; Cancel button
      ls_btn_cancel_x_pos=237
      ls_btn_cancel_y_pos=370
      ls_btn_cancel_y_pos=340
      ls_btn_cancel_width=85
      ls_btn_cancel_height=30
      
      [Logging]
      LogFile=xrdp.log
      LogLevel=DEBUG
      EnableSyslog=true
      SyslogLevel=DEBUG
      ; LogLevel and SysLogLevel could by any of: core, error, warning, info or debug
      
      [Channels]
      ; Channel names not listed here will be blocked by XRDP.
      ; You can block any channel by setting its value to false.
      ; IMPORTANT! All channels are not supported in all use
      ; cases even if you set all values to true.
      ; You can override these settings on each session type
      ; These settings are only used if allow_channels=true
      rdpdr=true
      rdpsnd=true
      drdynvc=true
      cliprdr=true
      rail=true
      xrdpvr=true
      tcutils=true
      
      ; for debugging xrdp, in section xrdp1, change port=-1 to this:
      #port=/tmp/.xrdp/xrdp_display_10
      
      ; for debugging xrdp, add following line to section xrdp1
      #chansrvport=/tmp/.xrdp/xrdp_chansrv_socket_7210
      
      
      ;
      ; Session types
      ;
      
      ; Some session types such as Xorg, X11rdp and Xvnc start a display server.
      ; Startup command-line parameters for the display server are configured
      ; in sesman.ini. See and configure also sesman.ini.
      #[Xorg]
      #name=Xorg
      #lib=libxup.so
      #username=ask
      #password=ask
      #ip=127.0.0.1
      #port=-1
      #code=20
      
      [Xvnc]
      name=Xvnc
      lib=libvnc.so
      username=ask
      password=ask
      ip=127.0.0.1
      port=-1
      #xserverbpp=24
      #delay_ms=2000
      ; Disable requested encodings to support buggy VNC servers
      ; (1 = ExtendedDesktopSize)
      #disabled_encodings_mask=0
      
      
      #[vnc-any]
      #name=vnc-any
      #lib=libvnc.so
      #ip=ask
      #port=ask5900
      #username=na
      #password=ask
      #pamusername=asksame
      #pampassword=asksame
      #pamsessionmng=127.0.0.1
      #delay_ms=2000
      
      #[neutrinordp-any]
      #name=neutrinordp-any
      #lib=libxrdpneutrinordp.so
      #ip=ask
      #port=ask3389
      #username=ask
      #password=ask
      
      ; You can override the common channel settings for each session type
      #channel.rdpdr=true
      #channel.rdpsnd=true
      #channel.drdynvc=true
      #channel.cliprdr=true
      #channel.rail=true
      #channel.xrdpvr=true
      ```
  - VirtualBox CentOS向けのrpmを手動でダウンロードし、ダブルクリック、install
  - VirtualBox 追加の作業
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
  - ネットワーク設定  
    - デスクトップにログインしVirtualBoxを起動
    - Toolの右のボタンからNetworkをクリック
    - アダプタ vboxnet0のIPv4アドレスを192.168.200.1に、DHCPサーバのEnable Serverのチェックをはずす（＝Disabledにする）
- Vagrant
  - Vagrant CentOS向けのrpmを手動でダウンロードし、ダブルクリック、install
  - プラグインをインストール
    ```console
    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-disksize
    ```
  - ゲストOSを設定・起動
    ```console
    $ mkdir -p ~/vargant/centos8
    $ cd ~/vargant/centos8
    $ vagrant init "generic/centos8"
    $ vi Vagrantfile
    $ cat Vagrantfile | grep -v -e "^\s*#" | grep -v "^\s*$"
    Vagrant.configure("2") do |config|
      config.vm.box = "generic/centos8"
      config.ssh.insert_key = false
      config.vbguest.auto_update = false
      config.vm.network "private_network", ip: "192.168.200.xxx"
      config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = "2048"
        vb.cpus = "2"
        vb.name = "centos8"
      end
    end    
    ```
  - ゲストOSを設定・起動
    ```console
    $ cd ~/vargant/centos8
    $ vagrant up
    $ vagrant ssh
    $ vagrant halt
    ### or $ sudo shutdown -h now
    ```
    - ```vagrant up```を実行したSSHセッションを切断したあと、別のSSHセッションを開いて、ゲストOSにSSH接続できることを確認
  - 問題
    - プラグイン vagrant-disksize が働いておらず、ディスクサイズが小さいままとなった。
    

### 備忘
- ```/sbin/vboxconfig``` の処理
- セクション 01 routines.shの読み込み
  ```console
  TARGET=`readlink -e -- "${0}"` || exit 1
  MY_PATH="${TARGET%/[!/]*}"
  cd "${MY_PATH}"
  . "./routines.sh"
  ```
  - readlinkコマンドで、シンボリックリンクのリンク先をたどる。
    - オプション ```-e``` で、シンボリックリンクを再帰的にたどり、対象の末尾がスラッシュ記号の場合はディレクトリを指定したものとみなす
    - オプション ```--``` は、それ以降のパラメータをオプションではなくファイル名とみなす。-で始まるファイル名でも処理できる。
    - リンク先
      ```console
      # ll /sbin/vboxconfig 
      lrwxrwxrwx 1 root root 38 Nov  6 16:38 /sbin/vboxconfig -> /usr/lib/virtualbox/postinst-common.sh*
      ```
  - 末尾を除去して、ディレクトリ ```/usr/lib/virtualbox/``` をMY_PATHに代入
  - ディレクトリ```$MY_PATH```に移動し
  - $MY_PATHに移動し
  - /usr/lib/virtualbox/routines.sh* を読み込む（sourceする）
    このスクリプトには、様々な関数が定義されている。

- セクション 02 引数の確認
  ```console
  START=true
  while test -n "${1}"; do
      case "${1}" in
          --nostart)
              START=
              ;;
          *)
              echo "Bad argument ${1}" >&2
              exit 1
              ;;
      esac
      shift
  done
  ```
- セクション 03 KDMSの削除
  ```console
  # Remove any traces of DKMS from previous installations.
  for i in vboxhost vboxdrv vboxnetflt vboxnetadp; do
      rm -rf "/var/lib/dkms/${i}"*
  done
  ```
- セクション 04 systemdユニットファイルのインストール
  ```console
  # Install runlevel scripts and systemd unit files
  install_init_script "${MY_PATH}/vboxdrv.sh" vboxdrv
  install_init_script "${MY_PATH}/vboxballoonctrl-service.sh" vboxballoonctrl-service
  install_init_script "${MY_PATH}/vboxautostart-service.sh" vboxautostart-service
  install_init_script "${MY_PATH}/vboxweb-service.sh" vboxweb-service
  finish_init_script_install
  
  delrunlevel vboxdrv
  addrunlevel vboxdrv
  delrunlevel vboxballoonctrl-service
  addrunlevel vboxballoonctrl-service
  delrunlevel vboxautostart-service
  addrunlevel vboxautostart-service
  delrunlevel vboxweb-service
  addrunlevel vboxweb-service
  
  ln -sf "${MY_PATH}/postinst-common.sh" /sbin/vboxconfig
  ```
- セクション 05 SELinuxパーミッションの設定
  ```console
  # Set SELinux permissions
  # XXX SELinux: allow text relocation entries
  if [ -x /usr/bin/chcon ]; then
      chcon -t texrel_shlib_t "${MY_PATH}"/*VBox* > /dev/null 2>&1
      chcon -t texrel_shlib_t "${MY_PATH}"/VBoxAuth.so \
          > /dev/null 2>&1
      chcon -t texrel_shlib_t "${MY_PATH}"/VirtualBox.so \
          > /dev/null 2>&1
      chcon -t texrel_shlib_t "${MY_PATH}"/components/VBox*.so \
          > /dev/null 2>&1
      chcon -t java_exec_t    "${MY_PATH}"/VirtualBox > /dev/null 2>&1
      chcon -t java_exec_t    "${MY_PATH}"/VBoxSDL > /dev/null 2>&1
      chcon -t java_exec_t    "${MY_PATH}"/VBoxHeadless \
          > /dev/null 2>&1
      chcon -t java_exec_t    "${MY_PATH}"/VBoxNetDHCP \
          > /dev/null 2>&1
      chcon -t java_exec_t    "${MY_PATH}"/VBoxNetNAT \
          > /dev/null 2>&1
      chcon -t java_exec_t    "${MY_PATH}"/VBoxExtPackHelperApp \
          > /dev/null 2>&1
      chcon -t java_exec_t    "${MY_PATH}"/vboxwebsrv > /dev/null 2>&1
      chcon -t bin_t          "${MY_PATH}"/src/vboxhost/build_in_tmp \
           > /dev/null 2>&1
      chcon -t bin_t          /usr/share/virtualbox/src/vboxhost/build_in_tmp \
           > /dev/null 2>&1
  fi
  ```
- セクション 06 起動
  ```console
  test -n "${START}" &&
  {
      if ! "${MY_PATH}/vboxdrv.sh" setup; then
          "${MY_PATH}/check_module_dependencies.sh" >&2
          echo >&2
          echo "There were problems setting up VirtualBox.  To re-start the set-up process, run" >&2
          echo "  /sbin/vboxconfig" >&2
          echo "as root.  If your system is using EFI Secure Boot you may need to sign the" >&2
          echo "kernel modules (vboxdrv, vboxnetflt, vboxnetadp, vboxpci) before you can load" >&2
          echo "them. Please see your Linux system's documentation for more information." >&2
      else
          start_init_script vboxdrv
          start_init_script vboxballoonctrl-service
          start_init_script vboxautostart-service
          start_init_script vboxweb-service
      fi
  }
  ```
  - vboxdrv.shを実行し、問題がなければ、各サービスをstartする。
  - SECURE boot関連で問題があれば、メッセージが表示される。
  - 各サービスはセクション04でenabledされているので、署名済みモジュールが再起動時にうまくロードされれば起動するはず。
    ```console
    # systemctl list-unit-files  | grep vbox
    # systemctl status vboxautostart-service.service
    # systemctl status vboxballoonctrl-service.service
    # systemctl status vboxdrv.service
    # systemctl status vboxweb-service.service
    ```
