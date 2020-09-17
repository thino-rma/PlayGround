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
  $ ansible all -m ping -i inventory
  $ ansible-inventory --list --yaml -i inventory
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
  
