### いくつかの忘れやすい事柄
- git/
  - README.md
- ssh/
  - Rlogin.md
  - config
- texteditor/
  - vim.md

### その他 備忘
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
- systemctlコマンド
  ```console
  $ sudo systemctl list-units --type=service
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
  $ lsof -Pi | grep LISTEN
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
  
