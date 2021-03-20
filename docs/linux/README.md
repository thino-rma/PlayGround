## Linux向け

### ソフトウェア
- htop
  - 管理ツール alternative for ```top```
- ncdu
  - 管理ツール alternative for ```du```
- vim
  - テキストエディタ
- micro
  - テキストエディタ
- git
  - リポジトリ管理
- img2sixel
  - コンソールで画像表示
  - install for Ubuntu
    ```console
    $ sudo apt-get install libsixel-bin
    ```
  - install for CentOS
    ```console
    # cd /usr/local
    # git clone https://github.com/saitoha/libsixel.git
    # cd libsixel
    # ./configure
    # make
    # make install
    # ldconfig
    ```
    
### Python開発
- miniconda
  - Python環境

### 検討
#### ファイラ―
- 検討状況
- fd
  - install for Ubuntu
    ```console
    $ sudo apt install fdclone
    ```
- vifm
  - ruby製

#### テキストエディタ
- 検討状況
  - vimに統一することにする。
    - キーバインドが簡潔（Ctrlが不要）なのが手にやさしい
    - オペレータとモーションが効率的
  - microをすすめる。（nanoよりも）
    - キーバインドがわかりやすい
    - デフォルトでマウスサポートがある
- 比較
  - nano
  - micro
  - vi/vim
  - emacs
- vim
  - カーソル移動
    - ```h```, ```l``` はカーソルを左右に移動させる
    - ```Left```, ```Right``` はカーソルを左右に移動させ、さらに行をまたぐ
      ちなみに、行をまたぐ設定は、以下で行う必要がある。
      ```console
      set whichwrap=b,s,[,],<,>
      ```
    - なので ```Ctrl-h```, ```Ctrl-l``` に```Left```, ```Right``` を設定したい
      しかし、```Ctrl-h``` が ```<BS>``` と同じ挙動になる。VT100の仕様？
    - というわけで、SSHクライアントで ```BS``` のかわりに ```DEL``` を送るようにして、vimで以下を設定
      ```console
      set backspace=indent,eol,start
      nnoremap <Char-0x7f>  <BS>
      vnoremap <Char-0x7f>  <BS>
      inoremap <Char-0x7f>  <BS>
      cnoremap <Char-0x7f>  <BS>
      ```
    - tmuxでは、.tmux.confに以下の設定を入れると、vimで期待する動作になる。当然、tmuxのコマンドモードではBSが使えなくなるのだが・・・。闇は深い。
      ```console
      bind-key -n Bspace send-keys C-h
      ```
  - 貼り付け
    - normal ```["x]p```  put the text [from register x] after the cursor N times (default is [""])
    - visual ```["x]p```  same as normal (default is [""])
    - insert ```<C-r> {register}``` insert the contents of a register
    - insert ```<C-o> p``` execute command 'q' and return to insert mode
    - command ```<C-r> {register}```  insert the contents of a register or object under the cursor as if typed
    - insert ```<C-o>``` not used
    - なので、commandモードとinsertモードでは、```C-v```で貼り付けできるようにしている。
    - すると、オリジナルの ```C-v``` が使えなくなって困るので、 ```C-\ C-v``` にマッピングしておく。
