## Linux向け

### ソフトウェア
- htop
  - 管理ツール alternative for ```top```
- ncdu
  - 管理ツール alternative for ```du```
- ydiff
  - python3製 差分を左右で比較表示するためのフィルタコマンド
  - install
    ```console
    $ mkdir -p ~/bin
    $ wget https://raw.githubusercontent.com/joshuarli/ydiff/master/ydiff -O ~/bin/ydiff
    $ chmod u+x ~/bin/ydiff
    ```  
  - usage
    ```console
    $ diff -up file1 file2 | ydiff | less
    ```
- vim
  - テキストエディタ
- micro
  - テキストエディタ
- git
  - リポジトリ管理
- img2sixel
  - コンソールで画像表示
  - install for Ubuntu
    [ラズパイに fdclone を導入する](http://dotnsf.blog.jp/archives/1073777442.html)
    ```console
    $ sudo apt install fdclone
    ```
  - install for CentOS  
    [CentOS 8 で FDclone のビルドに失敗する対策](https://qiita.com/arin/items/3548efe988cce4b2b956)
    ```console
    # dnf group install "Development Tools"
    # dnf --enablerepo=powertools install -y nkf
    # dnf install -y ncurses-devel    
    # cd /usr/local/src
    # wget https://hp.vector.co.jp/authors/VA012337/soft/fd/FD-3.01j.tar.gz
    # tar zxvf FD-3.01j.tar.gz
    # cd FD-3.01j
    # nkf --overwrite -w fd.spec
    # sed -i '33i%global debug_package %{nil}' fd.spec
    # sed -i "s/\* Tue Jul  7 2004/\* Wed Jul  7 2004/" fd.spec
    # sed -i "s/\* Tue Sep 17 2003/\* Wed Sep 17 2003/" fd.spec
    # cd ..
    # mv FD-3.01j.tar.gz FD-3.01j.tar.gz.org
    # tar zcvf FD-3.01j.tar.gz FD-3.01j
    # rpmbuild -tb --clean ./FD-3.01j.tar.gz
    # rpm -i /root/rpmbuild/RPMS/x86_64/FDclone-3.01j-1.x86_64.rpm
    ```
- fdclone
  - コンソール向けのファイラ― FDClone
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
