## Linux向け

### ソフトウェア
- delta
  - Rust製 diffを見やすくするためのフィルタコマンド
    - デフォルトは、伝統的なdiff表示となる。
    - オプション `-s` で、サイドバイサイド表示となる。
      - 全角文字があっても、表示がずれない。
      - ただし、長い行は省略される。
    - 自動でlessしてくれる。offにもできる。　`--paging never`
    - 幅を指定できる。　`-w 400`

  > fork版 ydiffの作者 joshuarli は、deltaを使ってるって言ってる。  
  > https://github.com/dandavison/delta

  - install
    バージョンが最新かどうか、気を付けて！ 
    ```console
    $ wget http://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/gcc-10-base_10-20200411-0ubuntu1_amd64.deb
    $ wget http://mirrors.xmission.com/ubuntu/pool/main/g/gcc-10/libgcc-s1_10-20200411-0ubuntu1_amd64.deb
    $ wget https://github.com/dandavison/delta/releases/download/0.7.1/git-delta_0.7.1_amd64.deb
    $ sudo dpkg -i gcc-10-base_10-20200411-0ubuntu1_amd64.deb libgcc-s1_10-20200411-0ubuntu1_amd64.deb git-delta_0.7.1_amd64.deb
    ```  
  - usage
    ```console
    $ diff -up file1 file2 | delta -s
    $ diff -up .tmux.conf.org .tmux.conf | delta -s -n --paging never -w 400
    ```
- ydiff
  - python3製 差分を左右で比較表示するためのフィルタコマンド
    - デフォルトでサイドバイサイド表示される。
      - 長い行は折り返されて表示される。
      - 全角文字があると、表示ずれる。

  > こちらが本家。  
  > https://github.com/ymattw/ydiff  
  > 以下の fork版 は残念ながらメンテナンスされていない。  
  > https://github.com/joshuarli/ydiff  
  > > UNMAINTAINED: I use delta now, here's my configuration.

  - install
    ```console
    $ mkdir -p ~/bin
    $ wget https://raw.githubusercontent.com/joshuarli/ydiff/master/ydiff -O ~/bin/ydiff
    $ chmod u+x ~/bin/ydiff
    ```  
  - usage
    ```console
    $ diff -up file1 file2 | ydiff -s | less
    ```
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
    [ラズパイに fdclone を導入する](http://dotnsf.blog.jp/archives/1073777442.html)
    ```console
    $ sudo apt install fdclone
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
  - rpm build script for CentOS8
    ```console
    # cat build_libsixel_rpm.sh 
    #!/bin/bash
    
    NAME=libsixel
    VER=1.7.3
    GIT_URL=https://github.com/saitoha/${NAME}
    TAR_NAME=${NAME}-${VER}
    
    cd /usr/local/src
    
    [ -d ${NAME} ]            && rm -rf ${NAME}
    [ -f ${NAME}.spec ]       && rm -f  ${NAME}.spec
    [ -f ${TAR_NAME}.tar.gz ] && rm -f  ${TAR_NAME}
    
    cat <<EOF > ${NAME}.spec
    # check the macro: rpmbuild --showrc | less
    # %define lang ja  # define macro lang
    
    Summary: encoder/decoder implementation for DEC SIXEL graphics, and some converter programs.
    Name: libsixel
    Version: 1.7.3
    Release: 1
    Group: Applications/Graphics
    URL: https://github.com/saitoha/libsixel
    Source: libsixel-%{version}.tar.gz
    BuildRoot: %{_tmppath}/%{name}-%{version}-root
    License: The MIT License (MIT)
    BuildRequires: gcc
    BuildRequires: make
    BuildRequires: tar
    BuildRequires: coreutils
    BuildRequires: glibc
    
    %description
    SIXEL is one of image formats for printer and terminal
    imaging introduced by Digital Equipment Corp. (DEC). Its
    data scheme is represented as a terminal-friendly escape
    sequence. So if you want to view a SIXEL image file, all
    you have to do is "cat" it to your terminal.
    
    %global debug_package %{nil}
    %prep
    rm -rf \$RPM_BUILD_ROOT
    %setup -n %{name}
    
    %build
    %configure --prefix=/usr 
    make DESTDIR="\$RPM_BUILD_ROOT" 
    
    %install
    make DESTDIR="\$RPM_BUILD_ROOT" install
    
    %clean
    rm -rf \$RPM_BUILD_ROOT
    
    %post
    %files
    %defattr(-,root,root)
    %{_bindir}/img2sixel
    %{_bindir}/libsixel-config
    %{_bindir}/sixel2png
    %{_includedir}/sixel.h
    %{_prefix}/lib/python3.6/site-packages/libsixel/__init__.py
    %{_prefix}/lib/python3.6/site-packages/libsixel/__pycache__/__init__.cpython-36.opt-1.pyc
    %{_prefix}/lib/python3.6/site-packages/libsixel/__pycache__/__init__.cpython-36.pyc
    %{_prefix}/lib/python3.6/site-packages/libsixel/__pycache__/decoder.cpython-36.opt-1.pyc
    %{_prefix}/lib/python3.6/site-packages/libsixel/__pycache__/decoder.cpython-36.pyc
    %{_prefix}/lib/python3.6/site-packages/libsixel/__pycache__/encoder.cpython-36.opt-1.pyc
    %{_prefix}/lib/python3.6/site-packages/libsixel/__pycache__/encoder.cpython-36.pyc
    %{_prefix}/lib/python3.6/site-packages/libsixel/decoder.py
    %{_prefix}/lib/python3.6/site-packages/libsixel/encoder.py
    %{_libdir}/libsixel.a
    %{_libdir}/libsixel.la
    %{_libdir}/libsixel.so
    %{_libdir}/libsixel.so.1
    %{_libdir}/libsixel.so.1.0.6
    %{_libdir}/pkgconfig/libsixel.pc
    %{_datarootdir}/bash-completion/completions/img2sixel
    %{_datarootdir}/man/man1/img2sixel.1.gz
    %{_datarootdir}/man/man1/sixel2png.1.gz
    %{_datarootdir}/man/man5/sixel.5.gz
    %{_datarootdir}/zsh/site-functions/_img2sixel
    
    %changelog
    * Sat Dec 10 2016 saitoha
    - for 1.7.3
    EOF
    
    git clone ${GIT_URL} -b v${VER}
    cp ./${NAME}.spec ${NAME}/
    
    tar zcvf ${TAR_NAME}.tar.gz ${NAME}/
    rpmbuild -tb --clean ./${TAR_NAME}.tar.gz
    
    # bash build_libsixel_rpm.sh 
    # find ~/rpmbuild/ | grep libsixel
    /root/rpmbuild/RPMS/x86_64/libsixel-1.7.3-1.x86_64.rpm
    ```
- fdclone
  - コンソール向けのファイラ― FDClone
  - install for Ubuntu
    ```console
    $ sudo apt-get install libsixel-bin
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
    
### Python開発
- miniconda
  - Python環境
  - 2020/09にAnacondaの利用規約が変更され、大規模（200名以上？）な商用利用で有償化された。
  - How to do?  
    (1) remove defaults channel  
    ```
    conda config --remove channels defaults  
    conda config --show channels
    ```
    (2) install with options -c conda-forge --override-channels  
    option `-c conda-forge` automatically referes defaults channel.  
    option `--override-channels`  ensures that conda searches only your specified channel and no other channels  
    ```
    conda install pandas -c conda-forge --override-channels
    ```

### 検討
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
    - insert ```<C-o> p``` execute command 'p'(put) and return to insert mode
    - command ```<C-r> {register}```  insert the contents of a register or object under the cursor as if typed
  - 以下は古い記述。`C-v`で貼り付けは行わないことにした。というか、vimに慣れることにした。
    - commandモードとinsertモードでは、```C-v```で貼り付けできるようにしている。
    - すると、オリジナルの ```C-v``` が使えなくなって困るので、 ```C-\ C-v``` にマッピングしておく。
