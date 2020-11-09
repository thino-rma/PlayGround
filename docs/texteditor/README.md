### Ctrl-hとBackspaceが同じキーコードとなる問題
- 参考URL
  - http://www.hypexr.org/linux_ruboff.php
  - http://www.afterstep.org/keyboard.html
- ASCII文字としてのBackspaceとDelete
  - ASCII文字BSは十進数8、16進数で0x08、リテラル表記で'^H'である。
  - ASCII文字DELは十進数127、16進数で0x7f、リテラル表記で'^?'である。
- vt100ターミナルのエミュレーション（デフォルト）で送信されるキーコード
  - Ctrl-hキーが押下されると、'^H' (0x08) を送信するため、tty側で delete left が実行される。
  - Backspaceキーが押下されると、'^H' (0x08) を送信するため、tty側で delete left が実行される。
  - Deleteキーが押下されると、"\e[3~" を送信するため、tty側で delete が実行される。
  - 上記の挙動の問題点
    - Ctrl-hとBackspaceの入力が同じため、プログラム側が区別できない。
  - 備考
    - ttyとは、標準入出力となっている端末デバイス(制御端末、controlling terminal)の名前を表示するUnix系のコマンドである。 
    - なお、元来 tty とは teletypewriter（テレタイプライター：遠隔タイプライター）を意味する。
- Ctrl-hとBackspaceを区別するための設定概要
  - 使用している端末（vt100ターミナルエミュレータ）が、以下の挙動を示すように設定する。
    - (A-1) Ctrl-h で "^H" (0x08) を送信する。（これはデフォルトの挙動なので設定は不要。）
    - (A-2) Backspace で '^?' (0x7f) を送信する。（これには設定Aが必要。）
    - (A-3) Delete で "\e[3~" を送信する。（これはデフォルトの挙動なので設定は不要。）
  - 次に、bashシェル側で、以下の挙動を示すように tty を設定する。
    - (B-1) "^H" で delete left を実行する。（これはデフォルトの挙動なので設定は不要。）
    - (B-2) '^?' (0x7f) で delete left を実行する。（これには設定Bが必要。）
    - (B-3) "\e[3~" で delete  を実行する。（これはデフォルトの挙動なので設定は不要。）
  - テキストエディタ側で、必要に応じて、以下の挙動を示すように設定する。
    - (C-1) 基本的に "^H" で 任意の機能を実行する。
    - (C-2) 基本的に '^?' (0x7f) で delete left を実行する。
    - (C-3) 基本的に "\e[3~" で delete を実行する。（これはデフォルトの挙動なので設定は不要。）
- 設定A
  - GNOME Terminal (Linux GNOMEデスクトップ)
    - open the Edit manu and click on Profile preferences. Switch to the Compatibility tab and you should get these options:  
      Preferences - New Profile - Compatiblity Tab - Backspace key generates: ASCII DELL (change from ASCII BS)  
      Preferences - New Profile - Compatiblity Tab - Delete key generates: Escape sequence (as default)  
    - See https://askubuntu.com/questions/946492/backspace-doesnt-work-inside-running-bash-script
  - TeraTerm (Windows)
    - メニューから「設定→キーボード」を選択。  
      DELを送信するキー グループボックスの一覧で  
      「Backspaceキー」のチェックを入れる  
      「Deleteキー」のチェックをはずす
    - Keyboard ([Setup] メニュー) https://ttssh2.osdn.jp/manual/4/ja/menu/setup-keyboard.html  
      |Transmit DEL by:|description|
      |:--------------:|:----------|
      |Backspace key|このオプションが選択されると backspace キーを押した時に DEL 文字 (ASCII $7F) が送出されます。 選択されないと BS 文字 (ASCII $08) が送出されます。  <br />また、このオプションが選択された(選択されない)時でも Ctrl+Backspace で BS (DEL) 文字を送出できます。|
      |Delete key|このオプションが選択されると Delete (Del) キーを押した時に DEL 文字が送出されます。 このオプションが選択されない場合、Delete キーの機能は キーボード設定ファイル により決定されます。|
  - RLogin (Windows)
    - サーバ設定から スクリーン &gt; 制御コード  
      エスケープシーケンス グループボックスの一覧で、  
      「67 BSキーでBS(08)を送信 BSキーでDEL(7F)を送信」のチェックを外す
    - 2.7.7 拡張オプション一覧 http://nanno.dip.jp/softlib/man/rlogin/ctrlcode.html#OPT
      |番号|略号|設定 DECSET （CSI ?Pn h)|解除 DECRST （CSI ?Pn l)|
      |:--:|:--:|:--:|:--:|
      |67|DECBKM|BSキーでBS(08)を送信|BSキーでDEL(7F)を送信 (2.22.7から修正)|
    - 備考：接続後のTERM環境変数は ```xterm```である。
  - 確認方法
    - 以下のコマンドを実行し、任意のキー（Ctrl-h、Backspace、Deleteなど）を押下して Enter を押下すると、送られたコードが表示される。Ctrl-D（あるいはCtrl-C）で終了できる。
      ```console
      $ sed -n l
      ```
  - 備考
    - Ctrl-d は実行中のプロセス（上記ではsedコマンドのプロセス）に標準入力の終了を通知する。（実行中のプロセスは標準入力からeofを読み込む。）
    - Ctrl-c は実行中のプロセス（上記ではsedコマンドのプロセス）を終了を通知する。（実行中のプロセスがSIGINTシグナルを受信する。）
    - TERM環境変数により、端末アプリケーションの情報を識別します。これらの情報はterminfoとよばれ、infocmpコマンドで表示することができる。
    - tmuxは、デフォルト設定にて起動すると、TERM環境変数が ```screen``` となる。あるいは ~/.tmux.conf にて ```set -g default-terminal "screen-256color"``` を設定すれば、TERM環境変数が ```screen-256color``` となり、24bitカラー表示を可能にする。
      > Fedora の /usr/share/terminfo/s/screen-256color を CentOS にコピー（rsinc）しただけで、うまくいくようです。  
      > ```rsync -tv /usr/share/terminfo/s/screen-256color root@the_host:/usr/share/terminfo/s```
    
- 設定B
  - bashセッションで読み込まれる ```~/.bashrc``` に以下を追記する。（直接 ```$ stty erace '^?'```と実行してもよい）
    ```console
    stty erase '^?'
    ```
  - 確認方法
    ttyの設定状況は、以下のコマンドを実行して表示できる。erase項目を確認する。
    ```console
    $ stty -a
    ```
- 設定C
  - Vim
  - Vimでの確認方法
  - Emacs
  - Emacsでの確認方法
  - nano
  - nanoでの確認方法
  - micro
  - microでの確認方法
