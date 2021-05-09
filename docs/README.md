### いくつかの忘れやすい事柄
- html
  - ゼロ幅スペース &#8203;```&#8203;```
- products
  - trickle 帯域制限
  - websocketd [joewalnes/websocketd](https://github.com/joewalnes/websocketd)
    - websocketd is a small command-line tool that will wrap an existing command-line interface program, and allow it to be accessed via a WebSocket.
  - moosefs
    - オープンソースのPOSIX準拠の分散ファイルシステム オープンソース版では単一障害点あり
  - bcachefs
    - 次世代の CoW ファイルシステム
  - ChironFS FUSE based filesystem that implements replication at the filesystem level like RAID 1 does at the device level.
    - [Rustで学ぶFUSE (1) リードオンリーなファイルシステムの実装](https://qiita.com/narumatt/items/2dfc3aedf3aafd459e81)
- git/
  - README.md
- python/
  - README.md
- ssh/
  - Rlogin.md
  - config
- texteditor/
  - vim.md

### その他 備忘
- Ubuntu apache2設定
  - http://www.yamamo10.jp/yamamoto/comp/home_server/WEB_server3/apache/index.php
  - apachectl
  - a2ensite / a2dissite
  - a2enconf / a2disconf
  - a2enmod / a2dismod
  - a2ensite / a2dissite
  - なぜコマンドを分ける？サブコマンドにまとめて、タブ補完するべき。
- 代替コマンド
  - htopコマンド (topコマンドの代替)
    ```console
    sudo apt -y install htop
    sudo dnf -y install htop
    ```
    ```console
    $ htop
    ```
    キー```F1```でヘルプを参照できる。
  - ncduコマンド (duコマンドの代替)
    ```console
    sudo apt install ncdu
    sudo yum install ncdu 
    ```
    ```console
    $ ncdu 
    ```
    キー```?```でヘルプを参照できる。
  - fdコマンド (findコマンドの代替)
    fd-find
     
- dateコマンド
  短縮表示 ```%F``` や ```%R```, ```%T``` が使用できるものの、セパレータが入ってしまう。
  ```console
  $ echo `date '+%F'`                  # %F   full date: same as %Y-%m-%d
  $ echo `date '+%F %R'`               # %R   24-hour hour and minute: same as %H:%M
  $ echo `date '+%F %T'`               # %T   time : same as %H:%M:%S
  $ echo `date '+%Y-%m-%d'`
  $ echo `date '+%Y%m%d-%H%M%S'`       # 年月日-時分秒
  $ echo `date '+%Y%m%d-%H%M%S.%3N'`   # 年月日-時分秒.ミリ秒
  ```
  cronの設定ファイル中では、エスケープが必要です。
  ```console
  $ 5 * * * * root command >> command.log.`date +'\%Y\%m\%d'`
  ```
- findコマンド
  ```console
  ### 通常ファイル、深さ１、名前指定、日付判定、３日以上経過
  $ find ./log/ -type f -maxdepth 1 -name "test.log.*" -daystart -mtime +3 | grep `pwd`
  ### grepでカレントディレクトリの相対パス以下に制限
  $ find ./ -name "test.log.*" -daystart -mtime +3 | grep `\./`
  ### 相対ディレクトリだけに制限する
  $ find ./ -name "test.log.*" -daystart -mtime +3 | grep `\./`
  ### 絶対パスを除外する
  $ find ./ -name "test.log.*" -daystart -mtime +3 | grep -v "^/"
  ### 末尾が .YYYYMMDD など数字が続くもの
  $ find ./ -name "test.log.*" -daystart -mtime +3 | grep `\./` | grep -P ".\d+$" |
  ### 10件ずつ削除する
  $ find ./ -name "test.log.*" -daystart -mtime +3 | grep `\./` | xargs -r -n 10 rm
  ### リネーム
  $ find ./ -name "test.log.*" -daystart -mtime +3 -print0 | xargs -0 -r -I% echo % %.bak 
  ```
- OSごとのパッケージ管理  
  CentOS
  ```console
  $ rpm -qa | grep name    # list installed packages
  $ rpm -ql package_name   # list files from the package
  ```
  Ubuntu
  ```console
  $ dpkg -l | grep name    # list installed packages
  $ dpkg -L package_name   # list files from the package
  ```
- ホスト名の設定
  ```console
  $ sudo hostnamectl set-hostname paddington
  ```
- PukiwikiにMarkdownを書く
  ```console
  #markdown{{
  ここにMarkdownを書こう。
  }}
  ```
- gitコマンド
  ```console
  # after add, remove it from stage (HEADにないものを)
  git rm --cached -r file_name
  # after add, reset it (HEADにあるものを）
  git reset file_name
  ```
- diffコマンド
  ```console
  $ diff -up orig work
  $ diff -uprN origdir workdir
  ```
- ansibleコマンド
  ```console
  $ ansible all -m ping -i inventory/hosts
  $ ansible all -m shell -a "ls -alF" -i inventory/hosts
  $ ansible-inventory --list --yaml -i inventory/hosts
  $ ansible-playbook playbook.yml -i inventory/hosts --syntax-check
  ```
- systemctlコマンド, journalctlコマンド
  ```console
  $ sudo systemctl list-units --type=service
  $ sudo systemctl list-unit-files | grep service
  $ sudo systemctl start service   | systemctl status service
  $ sudo systemctl restart service | systemctl status service
  $ sudo systemctl stop service    | systemctl status service
  $ sudo systemctl status service
  $ sudo journalctl -u hello
  $ sudo journalctl -f
  ```

- netstatコマンド ssコマンド 
  netstatコマンドは非推奨。ss コマンドを使いましょう。
  TCPのLISTENポートを番号で表示します。
  ```console
  $ ss -ltn
  ```

- ipコマンド
  ```console
  $ ip a   # address show
  $ ip n   # neighbour (ARP or NDISC)
  $ ip r   # routing table
  ```

- lsofコマンド
  TCPのLISTENポートを番号で表示します。
  ```console
  $ sudo lsof -Pi | grep LISTEN
  ```
  コマンドが見つからない場合は、以下でインストールできます。
  ```console
  $ sudo yum -y install lsof
  ```
  
- menu in script 
  ```console
  #!/bin/bash
  # Bash Menu Script Example
  
  PS3='Please enter your choice: '
  options=("Option 1" "Option 2" "Option 3" "Quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "Option 1")
              echo "you chose choice 1"
              ;;
          "Option 2")
              echo "you chose choice 2"
              ;;
          "Option 3")
              echo "you chose choice $REPLY which is $opt"
              ;;
          "Quit")
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
  ```

- dialogコマンド
  ```console
  $ sudo apt-get install dialog
  $ sudo yum install dialog
  $ sudo dnf install dialog
  ```
  
- mariadb
  ```console
  $  mysql -uroot -p
  > SHOW VARIABLES LIKE "char%";
  +--------------------------+------------------------------+
  | Variable_name            | Value                        |
  +--------------------------+------------------------------+
  | character_set_client     | utf8mb4                      |
  | character_set_connection | utf8mb4                      |
  | character_set_database   | utf8mb4                      |
  | character_set_filesystem | binary                       |
  | character_set_results    | utf8mb4                      |
  | character_set_server     | utf8mb4                      |
  | character_set_system     | utf8                         |
  | character_sets_dir       | /usr/share/mariadb/charsets/ |
  +--------------------------+------------------------------+
  ```

### atコマンドの使い方
- atコマンドの紹介
  - atdデーモンは予約されたコマンドを指定された日時に実行する。
  - atコマンドで予約を行う。
  - atqコマンド（あるいはat -l）で予約を一覧する。
- 使用
  - ファイアウォールの設定を変更するとき、変更後にSSH接続できなくなったときのために、ファイアウォールを停止するためのコマンドを予約しておく。
    ```console
    echo "systemctl stop firewalld" | at now + 5 minutes
    ```
- インストール
  - CentOS7
    ```console
    $ yum install at
    $ systemctl start atd
    $ systemctl enable atd
    ```
  - CentOS6
    ```console
    $ yum install at
    $ /etc/init.d/atd start
    $ chkconfig on atd
    ```
- コマンド
  - 登録 対話的（Ctrl-dで終了）
    ```console
    $ at 15:00
    ```
  - 登録 パイプ
    ```console
    $ echo "logger \"test `date`\"" | at 15:00
    $ echo "systemctl stop firewalld" | at now + 5 minutes
    ```
  - 登録 ファイル指定
    ```console
    $ at 15:00 -f test.sh
    ```
  - 予約リストの表示
    ```console
    $ atq
    $ at -l
    ```
  - 予約削除
    ```console
    $ atrm JOBNO
    $ at -r JOBNO
    $ at -d JOBNO
    ```
