### いくつかの忘れやすい事柄
- git/
  - README.md
- ssh/
  - Rlogin.md
  - config
- texteditor/
  - vim.md

### その他 備忘
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
  
