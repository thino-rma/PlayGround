### キーマッピングにおける基本原則
- 考慮する事項
  - できる限りデフォルトをオーバーライドしない。
    - 設定されていない環境で作業するときに事故を起こさないため。
  - デフォルトを上書きする場合でも、できる限りデフォルトキーマップをバックアップする。
  - デフォルトを上書きすべき理由を明確にする。
- 考慮する事項 (1) vimで使えないキー
  - RLogin（SSHクライアント）のキーマッピング  
  　```Shift-INSERT```は```$PASTE```に設定
  - tmuxのキーマッピング (基本は Meta付き）
    ```
    ### prefix key
    unbind C-b
    set -g prefix C-q
    bind C-q send-prefix
    
    ### short cut keys
    bind-key -n M-F7     select-pane -t :.-
    bind-key -n M-F8     select-pane -t :.+
    bind-key -n M-C-F7   previous-window
    bind-key -n M-C-F8   next-window
    
    ### short cut keys F9, F10, F11, F12 with Alt: h,j,k,l
    # without Shift, change pane
    bind-key -n M-F9  select-pane -L
    bind-key -n M-F10 select-pane -D
    bind-key -n M-F11 select-pane -U
    bind-key -n M-F12 select-pane -R
    
    # with Shift, change size
    bind-key -n M-S-F9    resize-pane -L 1
    bind-key -n M-S-F10   resize-pane -D 1
    bind-key -n M-S-F11   resize-pane -U 1
    bind-key -n M-S-F12   resize-pane -R 1
    
    bind-key -n M-C-S-F9  resize-pane -L 5
    bind-key -n M-C-S-F10 resize-pane -D 5
    bind-key -n M-C-S-F11 resize-pane -U 5
    bind-key -n M-C-S-F12 resize-pane -R 5
    
    ### copy mode
    # C-@ stands for NUL '\000' which is sent by C-Space on SSH client
    bind-key -n C-@ copy-mode
    ```
- 考慮する事項 (2) vimで使えると便利なキー
  - bashのキーマッピング、emacsのキーマッピング
    ```
    <C-b> cursor to left
    <C-f> cursor to right
    <M-b> Move back to the start of the current or previous word.
    <M-f> Move forward to the end of the next word.
    <C-a> cursor to begin of command-line
    <C-e> cursor to end of command-line
    <C-d> delete character under the cursor
    <C-u> Remove all characters between the cursor position and the beginning of the line.
    <C-k> Remove all characters between the cursor position and the end of the line.
    <C-w> Cut from cursor to previous whitespace
    <C-l> Clear the screen leaving the current line at the top of the screen.
    ```

### ESCの代替キーについての検討
- 調査：```not used``` related keys
  |mode|key|description|
  |:--:|:--|:----------|
  |i   |```CTRL-F```|not used (but by default it's in 'cinkeys' to re-indent the current line)|
  |n   |```CTRL-F```|scroll N screens Forward|
  |i   |```CTRL-S```|not used or used for terminal control flow|
  |n   |```CTRL-S```|not used, or used for terminal control flow|
  |i   |```CTRL-\ others```|not used|
  |n   |```CTRL-\ others```|not used|
  |i   |```CTRL-@```|insert previously inserted text and stop insert|
  |n   |```CTRL-@```|not used|
  |i   |```CTRL-K {char1} {char2}```|enter digraph|
  |n   |```CTRL-K```|not used|
  |i   |```CTRL-Q```|same as CTRL-V, unless used for terminal control flow|
  |n   |```CTRL-Q```|not used, or used for terminal control flow|
  |i   |```CTRL-_```|When 'allowrevins' set: change language (Hebrew, Farsi)|
  |n   |```CTRL-_```|not used|
- 調査： 実際にESCの代わりに使用するキー
  |mode|key|description|
  |:--:|:--|:----------|
  |i   |```inoremap jj <ESC>```|because very useful.|
  |vic |```CTRL-[```|i default: same as ```<Esc>```|
  |vic |```vnoremap <C-i>      <ESC>```<br />```inoremap <C-i>      <ESC>```<br />```cnoremap <C-i>      <ESC>```|i default: same as <Tab>|
  |vic |```vnoremap <C-\><C-\> <ESC>```<br />```inoremap <C-\><C-\> <ESC>```<br />```cnoremap <C-\><C-\> <ESC>```|default: not used.|
  
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
    - (A-3) Delete で "\e[3~" を送信する。（これはRLoginのデフォルトのキー設定なので設定は不要。）
  - 次に、bashシェル側で、以下の挙動を示すように tty を設定する。
    - (B-1) "^H" で delete left を実行する。（これはデフォルトの挙動なので設定は不要。）
    - (B-2) '^?' (0x7f) で delete left を実行する。（これには設定Bが必要。）
    - (B-3) "\e[3~" で delete  を実行する。（これはデフォルトの挙動なので設定は不要。）
  - ソフトウェア（テキストエディタなど）側で、必要に応じて、以下の挙動を示すように設定する。
    - (C-1) 基本的に "^H" で 任意の機能を実行する。（vimなら、```<Left>```に設定するかもしれない。
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
  - bashセッションで読み込まれる ```~/.bashrc``` に以下を追記し、ログインしなおす。（直接 ```$ stty erace '^?'```と実行してはいけない。）
    ```console
    stty erase ^?
    ```
    > RLoginでの入力方法は 設定Aを行っていれば、C-v BS、設定Aを行っていなければ C-v C-S-8 である。
    > 以下のようにしておくとよい。
    > ```console
    >   ## TODO replace with C-v C-S-8(^?)
    > [[ -n "$TMUX" ]] && stty erase ^?
    > [[ "$TERM" =~ ^screen ]] && stty erase ^?
    > ```
  - 確認方法
    ttyの設定状況は、以下のコマンドを実行して表示できる。erase項目を確認する。
    ```console
    $ stty -a | grep " erase "
    intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = M-^?; eol2 = M-^?;
    ```
- 設定C
  - Vim
    - .vimrc に設定を行う
      ```console
      " set '^?' (0x7f) to Backspace
      noremap <Char-0x7f> <BS>
      
      " set 'C-h'(='^H') to Left
      nnoremap <C-h> <Left>
      ```
  - Vimでの確認方法
    - insert mode で C-v を押下した後、任意のキーを入力すると、キーコードが表示される。
  - Emacs
  - Emacsでの確認方法
  - nano
  - nanoでの確認方法
  - micro
    - 参考URL https://qiita.com/ht_deko/items/c47fb602d090e5a2bfa8
  - microでの確認方法
  - tmux
    - .tmux.conf に設定を行う
      ```console
      # set '^?' (0x7f) to 'C-h'
      # in tmux command mode, use C-h or C-u to delete left
      bind-key -n Bspace send-keys C-h
      ```
- 補足事項
  - 確認すべき挙動
    - RLogin-Bashでの入力
    - RLogin-Bash-vimでの入力
    - RLogin-Bash-ssh-Bashでの入力
    - RLogin-Bash-ssh-Bash-vimでの入力
    - RLogin-Bash-tmux-コマンドモードでの入力
    - RLogin-Bash-tmux-Bashでの入力
    - RLogin-Bash-tmux-Bash-vimでの入力
    - RLogin-Bash-tmux-Bash-ssh-Bashでの入力
    - RLogin-Bash-tmux-Bash-ssh-Bash-vimでの入力
  - 設定D tmuxには、キーバインド設定として、以下のようにする例が見つかる。
    ```console
    bind-key -n Bspace send-keys C-h
    ```
  - 設定A あり、設定B なし、設定D なし　の場合、tmux起動直後のCtrl-hが ```^?``` となってしまう。
  - 設定A あり、設定B なし、設定D あり　の場合、tmux起動直後のCtrl-hが ```^H``` のままになるが、tmuxセッション内でのコマンドモードのBackSpaceが ```^?``` （豆腐表示）となってしまう。
  - 設定A あり、設定B あり、設定D なし　の場合、よさそう
  - 設定A あり、設定B あり、設定D あり　の場合、tmux起動直後のBackSpaceが ```^H``` となってしまう。
