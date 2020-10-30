### いくつかの忘れやすい事柄
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

- netstatコマンド
  netstatコマンドは非推奨。ss コマンドを使いましょう。
  TCPのLISTENポートを番号で表示します。
  ```console
  $ ss -ltn
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
