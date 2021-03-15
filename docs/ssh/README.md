### ssh公開鍵の手動登録
- 接続したらやること
  ```console
  mkdir ~/.ssh
  chmod 700 ~/.ssh
  touch ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys
  # add public key
  vi ~/.ssh/authorized_keys
  ```
### ssh-agent の活用
- ssh-agentを自動起動する  
  以下のコードを .bashrc に追記
  ```console
  if [ -z "$SSH_AGENT_PID" ]; then
    RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep - grep | wc -l | tr -d '[:space:]'`"
    if [ "$RUNNING_AGENT" = "0" ]; then
      ssh-agent -s &> .ssh/ssh-agent
    fi
    eval `cat .ssh/ssh-agent` > /dev/null 2>&1
  fi
  ```
- ssh-addでキーに対するパスフレーズを追加する
  ```console
  $ ssh-add
  $ ssh-add ~/.ssh/id_rsa
  ```

### ssh秘密鍵から公開鍵を作成
- 方法
  ```console
  ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
  ```
  秘密鍵のパーミッションは600に設定しておくこと。
