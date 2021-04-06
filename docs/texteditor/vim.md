### about key mapping
- URL
  - [vim index JP](https://vim-jp.org/vimdoc-ja/vimindex.html)
  - [vim index EN](https://vim-jp.org/vimdoc-en/vimindex.html)
  - [Consistent BackSpace and Delete Configuration](http://web.archive.org/web/20120621035133/http://www.ibb.net/~anne/keyboard/keyboard.html)
  - [Fix backspace in less](https://thomer.com/howtos/backspace_in_less.html)
    - これは必要なかった。```stty erase '^?'``` で解決。
  - [How to fix the backspace/ruboff key in Emacs/Xterm](http://www.hypexr.org/linux_ruboff.php)
- RLogin側の設定
  - 制御コード
    - 「?67 Set BSキーでBSを送信 / Reset BSキーでDELを送信」のチェックをはずす
      > チェックが入っていると、 BSキーで ```^h```（これは C-h とかぶる） を送信する。チェックを外すと、BSキーで ```^?``` を送信する。  
      > 目的：vimで、BSキーと C-h を別々にマッピングするのに必要。
  - キーコード
    - 「1.modifyCursorKeys」を、「UP,DOWN,RIGHT,LEFT,PRIOR,NEXT,HOME,END,DELETE」（INSERTを除く）に対して「2」を設定。
      > 注意：INSERTを除いていることに注意する。これは、RLogin のショートカットに Shift-Insert を $PASTE にマッピングしているため。  
      > 目的：vimで、カーソルキーなどのキーに機能を割り付けるとき、修飾コードを追加することで、使いやすくする。
    - 「2.modifyCursorKeys」を、「F1-F12」（デフォルト）に対して「2」を設定。
      > 目的：vimで、ファンクションキーに機能を割り付けるとき、修飾コードを追加することで、使いやすくする。
    - 「3.modifyKeypadKeys」を、「PAD0-PAD9,PADMUL,PADADD,PADSEP,PADSUB,PADDEC,PADDIV」（デフォルト）に対して「2」を設定。
      > 「-1」（デフォルト）の場合、Ctrlとキーパッドの「-」を入力すると、RLoginの挙動が不安定になった。（接続が応答しなくなる）  
      > 「2」にした場合、Ctrlとキーパッドの「-」を入力しても、RLoginの挙動が不安定にならない。  
      > vimの割り付けには使用しない。
    - 「4.modifyOtherKeys」を、「ESCAPE,RETURN,BACK,TAB」（デフォルト）に対して「-1」（デフォルト）を設定。
      > vimの割り付けには使用しない。
    - 「5.modifyStringKeys」を、「SPACE,0-9,A-Z」（デフォルト）に対して「-1」（デフォルト）を設定。
      > vimの割り付けには使用しない。
    - 「modifyKeysがメニューのショートカットキー設定より優先する」にチェックを入れる。
      > 目的：RLogin のショートカットをできる限り無効にしたいため。（RLoginでペイン分割などしたくない）
- ログインシェル bash の設定
  - コマンド ```stty erase '^?'``` を、```~/.my_bash_alias``` にて設定する。
    > コマンド ```stty``` は、端末ラインの設定を変更・表示する。
    > なお、```~/.inputrc``` は作成しない（そもそも調べてない）。作成するなら、```$include /etc/inputrc``` を追記する必要がある。  
    > ```/etc/inputrc``` ファイルはキーボードに応じたキーボードマップを定める。このファイルは入力に関連するライブラリ Readline が利用する。
  - bashのキーバインドについて
    - see .my_bash_alias
  - ノーマル  
    この状況においては、C-hキーとBackspaceキーで ```^H``` が送信される。  
    この状況においては、```stty -a``` で ```erace = ^H``` と表示される。
    | 入力          |bash                        |vim ```i C-v```|```sed -n l``` |
    |:-------------:|:---------------------------|:--------------|:--------------|
    |```C-h```      |カーソル位置の前の文字を削除|```^H```       |カーソル位置の前の文字を削除|
    |```Backspace```|カーソル位置の前の文字を削除|```^H```       |カーソル位置の前の文字を削除|
    |```Delete```   |カーソル位置の文字を削除    |```^[[3~```    |```^[[3~``` ```\033[3~$```|
  - (1) RLoginで、「BSでBSを送信」のチェックをはずす。「BSでDELを送信」の状態にする。  
    この状況においては、C-hキーで ```^H``` が、Backspaceキーで ```^?``` が送信される。  
    RLoginの接続時に、bashとさまざまな情報をやり取りし、初期化する。
    この状況においては、```stty -a``` で ```erace = ^H``` と表示される。
    | 入力          |bash                        |vim ```i C-v```|```sed -n l``` |
    |:-------------:|:---------------------------|:--------------|:--------------|
    |```C-h```      |カーソル位置の前の文字を削除|```^H```       |カーソル位置の前の文字を削除|
    |```Backspace```|カーソル位置の前の文字を削除|```^?```       |```^?``` ```\177$```|
    |```Delete```   |カーソル位置の文字を削除    |```^[[3~```    |```^[[3~``` ```\033[3~$```|
  - (2) (1) に加えて ```stty erase ^?```を実行する。  
    この状況においては、C-hキーで ```^H``` が、Backspaceキーで ```^?``` が送信される。  
    この状況においては、```stty -a``` で ```erace = ^?``` と表示される。  
    | 入力          |bash                        |vim ```i C-v```|```sed -n l``` |
    |:-------------:|:---------------------------|:--------------|:--------------|
    |```C-h```      |```^H```                    |```^H```       |カーソル位置の前の文字を削除|
    |```Backspace```|カーソル位置の前の文字を削除|```^?```       |```^?``` ```\177$```|
    |```Delete```   |カーソル位置の文字を削除    |```^[[3~```    |```^[[3~``` ```\033[3~$```|
- tmux側の設定（tmux経由の場合でも、うまく動くように）
  - オプション
    ```console
    set-option -g default-terminal screen-256color
    set -g terminal-overrides "xterm*:colors=256:kLFT2=\e[2D:kRIT2=\e[2C:kUP2=\e[2A:kDN2=\e[2B:kLFT3=\e[3D:kRIT3=\e[3C:kUP3=\e[3A:kDN3=\e[3B:kLFT4=\e[4D:kRIT4=\e[4C:kUP4=\e[4A:kDN4=\e[4B:kLFT5=\e[5D:kRIT5=\e[5C:kUP5=\e[5A:kDN5=\e[5B:kLFT6=\e[6D:kRIT6=\e[6C:kUP6=\e[6A:kDN6=\e[6B:kLFT7=\e[7D:kRIT7=\e[7C:kUP7=\e[7A:kDN7=\e[7B:kLFT8=\e[8D:kRIT8=\e[8C:kUP8=\e[8A:kDN8=\e[8B"
    ```
  - キーバインド
    - 奇妙に思えるが、以下の設定で、Ctrl-h を押下したときに、^H が送信される。（デフォルトでは、^? に変換されてしまう。Bspace はキーコード ^H = 0x08 を意味する）
      ```console
      bind-key -n Bspace send-keys C-h
      ```
      > 念のため、RLoginの設定でBackspaceを押下したときに ```^?``` を送るように設定変更している。デフォルトではBackpaceを押下したときに ```^h```（Ctrl-h）を送る。  
      > この設定変更をしないとき、Backspaceを押下すると、 ```^h```（Ctrl-h）が送られて、カーソル位置の前の文字が削除される。しかし、Ctrl-hでも同様にカーソル位置の前の文字が削除される。  
      > これでは、BackspaceとCtrl-hの機能を分離することができない。  
      > この設定変更をするとき、Backspaceを押下したときに ```^?``` が送られて、画面に ```^?``` が表示されてしまうが、Ctrl-hでカーソル位置の前の文字が削除される。  
      > この状況でやりたいことは、  
      > ①vimの設定をうまく整えることで、（tmux経由も含めて）vimにおいて、Backspaceでカーソル位置の前の文字を消し、C-hでカーソルを左に移動したいのである。  
      > どこかの設定をうまく整えることで、（tmux経由も含めて）bashにおいて、Backspaceでカーソル位置の前の文字を消すようにしたい。  
      > コマンド ```stty erase '^?'```で症状が改善するか要確認  
      > sttyコマンドは、標準入力からbashに渡す段階で変換を行うので（つまり、bashに限らずzshなどにも影響があるので）、子プロセスのvimに対しても影響が出てしまう気がする。（これでは意味がない？）  
      > あるいは、ファイル ```${HOME}/.inputrc``` に以下の記載で、改善するか要確認。  
      > ```console
      > $include  /etc/inputrc
      > "\e[3~": delete-char
      > # this is actually equivalent to "\C-?": delete-char
      > ```
      > inputrc ファイルはキーボードに応じたキーボードマップを定める。 このファイルは入力に関連するライブラリ Readline が利用するもので、このライブラリは Bash などのシェルから呼び出されます。 vimでreadlineを使っている部分も影響を受けると思われる。コマンドラインが影響を受けるか、要確認。  
      > あと、TERM環境変数との兼ね合いで変わる可能性がある？
- Default key mapping related to ESC
  - Default key action
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |v   |```<ESC>```|stop Visual mode||
    |v   |```<C-[>```|stop Visual mode||
    |i   |```<ESC>```|end insert mode||
    |i   |```<C-[>```|same as <ESC>||
    |c   |```<ESC>```|abandon command-line without executing it||
    |c   |```<C-[>```|same as <ESC>||
  - Alternative Keys for ESC
    |mode|key|action|custom mapping|
    |:--:|:--|:-----|:---|
    |i  |```jj```|not used|```inoremap jj <ESC>```|
    |n  |```<C-i>```|same as ```<TAB>```||
    |v  |```<C-i>```|not used?    |```vnoremap <C-i> <ESC>```|
    |i  |```<C-i>```|same as ```<TAB>```|```inoremap <C-i> <ESC>```|
    |c  |```<C-i>```|same as ```<TAB>```|```cnoremap <C-i> <ESC>```|
    |v  |```<C-\><C-\>```|not used|```vnoremap <C-\><C-\> <ESC>```|
    |i  |```<C-\><C-\>```|not used|```inoremap <C-\><C-\> <ESC>```|
    |c  |```<C-\><C-\>```|not used|```cnoremap <C-\><C-\> <ESC>```|

- Default key mapping for Cursor move
  - 備忘
    - 設定項目 whichwrap には h,l を含めないことが推奨されている。したがって、h,l キーで前行・次行には移動できない。
      ```console
      set whichwrap=b,s,<,>,[,]
      ```
    - 設定によらず（＝h,l を含めても含めなくても）、dl,cl,yl が行をまたぐことはない。
    - カーソルキーは含めるので、前行・次行に移動できる。```d<Right>```,```c<Right>```.```y<Right>```  などは行をまたぐ。
    - そこで、NORMALモード、INSERTモード、VISUALモードの３つで、C-h, C-j, C-k, C-l にそれぞれ ```<Left>```, ```<Down>```, ```<Up>```, ```<Right>``` を割り当てることにする。
    
  - Default key action
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |nv  |```h```|cursor N chars to the left||
    |nv  |```j```|cursor N lines downward||
    |nv  |```k```|cursor N lines upward||
    |nv  |```l```|cursor N chars to the right||
  - Alternative Keys for h,j,k,l
    |mode|key|action|custom mapping|
    |:--:|:--|:-----|:---|
    |i  |```<C-h>```|same as ```<BS>```|```inoremap <C-h> <Left>```|
    |i  |```<C-j>```|same as ```<CR>```|```inoremap <C-j> <Down>```|
    |i  |```<C-k>```|enter digraph|```inoremap <C-k> <Up>```<br />```inoremap <F7> <C-k>```|
    |i  |```<C-l>```|~~when 'insertmode' set: Leave Insert mode~~|```inoremap <C-l> <Right>```<br />```inoremap <C-i> <ESC>```|
    |nv  |```<C-h>```|same as "h"|```nnoremap <C-h> <Left>```<br />```vnoremap <C-h> <Left>```|
    |nv  |```<C-j>```|same as "j"|```nnoremap <C-j> <Down>```<br />```vnoremap <C-j> <Down>```|
    |nv  |```<C-k>```|not used|```nnoremap <C-k> <Up>```<br />```vnoremap <C-k> <Up>```|
    |nv  |```<C-l>```|redraw screen|```nnoremap <C-l> <Down>```<br />```vnoremap <C-l> <Down>```<br />```nnoremap <Leader><C-l> <C-l>```<br />```vnoremap <Leader><C-l> <C-l>```|

- Default key mapping related to Bash keymap
  - Bash keymap
    |key|action|
    |:--|:-----|
    |```<C-f>```|forward-char<br />Move forward a character.|
    |```<C-b>```|backward-char<br />Move back a character.|
    |```<C-a>```|beginning-of-line<br />Move to the start of the current line.|
    |```<C-e>```|end-of-line<br />Move back a character.|
    |```<C-d>```|delete-char<br />Delete  the  character  at point. |
    |```<C-u>```|unix-line-discard<br />Kill backward from point to the beginning of the line.|
    |```<C-k>```|kill-line<br />Kill the text from point to the end of the line.|
  
  - Default key action
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |i   |```<C-@>```|insert previously inserted text and stop insert||
    |i   |```<C-f>```|not used (but by default it's in 'cinkeys' to re-indent the current line)||
    |i   |```<C-b>```|not used||
    |i   |```<C-d>```|delete one shiftwidth of indent in the current line||
    |i   |```<C-a>```|insert previously inserted text||
    |i   |```<C-e>```|insert the character which is below the cursor||
    |i   |```<C-u>```|delete all entered characters in the current line||
    |i   |```<C-k>```|enter digraph||
    |i   |```<C-x>```|enter CTRL-X sub mode||
    |nv  |```<C-@>```|not used||
    |nv  |```<C-f>```|scroll N screens Forward||
    |nv  |```<C-b>```|scroll N screens Backwards||
    |nv  |```<C-d>```|scroll Down N lines (default: half a screen)||
    |nv  |```<C-a>```|add N to number at/after cursor||
    |nv  |```<C-e>```|scroll N lines upwards (N lines Extra)||
    |nv  |```<C-u>```|scroll N lines Upwards (default: half a screen)||
    |nv  |```<C-k>```|not used||
    |nv  |```<C-x>```|subtract N from number at/after cursor||
  - Key mappings for Bash keymap
    |mode|key|action|custom mapping|
    |:--:|:--|:-----|:---|
    |i   |```<C-@>```|insert previously inserted text and stop insert||
    |i   |```<C-f>```|not used (but by default it's in 'cinkeys' to re-indent the current line)|```inoremap <C-f> <C-o><Right>```|
    |i   |```<C-b>```|not used|```inoremap <C-b> <C-o><Left>```|
    |i   |```<C-d>```|delete one shiftwidth of indent in the current line|```inoremap <C-d> <C-o>"_x```|
    |i   |```<C-a>```|insert previously inserted text|```inoremap <C-a> <C-o>0```|
    |i   |```<C-e>```|insert the character which is below the cursor|```inoremap <C-a> <C-o>$```|
    |i   |```<C-u>```|delete all entered characters in the current line|```inoremap <C-u> <C-o>v0d```|
    |i   |```<C-k>```|enter digraph|this key is mapped for ```<Up>```.<br />```inoremap <C-k> <C-o>v$d```|
    |nv  |```<C-@>```|not used||
    |nv  |```<C-f>```|scroll N screens Forward|```nnoremap <C-f> <Right>```|
    |nv  |```<C-b>```|scroll N screens Backwards|```nnoremap <C-b> <Left>```|
    |nv  |```<C-d>```|scroll Down N lines (default: half a screen)|```nnoremap <C-d> "_x```|
    |nv  |```<C-a>```|add N to number at/after cursor|```nnoremap <C-a> 0```|
    |nv  |```<C-e>```|scroll N lines upwards (N lines Extra)|```nnoremap <C-e> $```|
    |nv  |```<C-u>```|scroll N lines Upwards (default: half a screen)|```nnoremap <C-u> v0d```|
    |nv  |```<C-k>```|not used|this key is mapped for ```<Up>```.<br />```nnoremap <C-k> v$d```|
    |c   |```<C-@>```|not used||
    |c   |```<C-f>```|default value for 'cedit': opens the command-line window; otherwise not used|```cnoremap <C-f> <Right>```|
    |c   |```<C-b>```|cursor to begin of command-line|```cnoremap <C-b> <Left>```|
    |c   |```<C-d>```|list completions that match the pattern in front of the cursor|```cnoremap <C-d> <DEL>```|
    |c   |```<C-a>```|do completion on the pattern in front of the cursor and insert all matches|```cnoremap <C-a> <Home>```|
    |c   |```<C-e>```|cursor to end of command-line|as is (cursor to end of command-line)|
    |c   |```<C-u>```|remove all characters|as is (Remove all characters between the cursor position and the beginning of the line.)|
    |c   |```<C-k>```|enter digraph|```cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>```<br />(Remove all characters between the cursor position and the end of the line.)|
    |c   |```<C-\>{num}```|not used|```cnoremap <C-\>1 <C-a>```<br />```cnoremap <C-\>2 <C-b>```<br />```cnoremap <C-\>3 <C-d>```<br />```cnoremap <C-\>4 <C-f>```|
    |c   |```<F7>```|not used|```cnoremap <F7> <C-k>```<br />```cnoremap <M-F7> <C-k>j```|
    
- InsertとDel
  - RLoginの設定により、INSERTには修飾コードが付かないが、Delには修飾コードが追加される。
  - vim設定
    ```console
    " <Insert> toggle insert/replace
    """ with Shift, nop for RLogin PASTE
    nnoremap <S-Insert> <nop>
    vnoremap <S-Insert> <nop>
    inoremap <S-Insert> <nop>
    
    " <Del>
    """ without modifier, delete character under the cursor
    " using blackhole register
    nnoremap <Del> "_d<Right>
    vnoremap <Del> "_d
    inoremap <Del> <C-o>"_d<Right>
    
    """ with Shift, delete character before the cursor
    " using blackhole register
    nnoremap <S-Del> "_d<Left>
    vnoremap <S-Del> "_d
    inoremap <S-Del> <C-o>"_d<Left>
    ```
- Backspace
  - RLoginの設定により、BSには修飾コードが付かない。さらに、送信されるコードは ```^?``` (= 127 = 0x7f) である。
  - vim設定
    ```console
    nnoremap <Char-0x7f>  <BS>
    vnoremap <Char-0x7f>  <BS>
    inoremap <Char-0x7f>  <BS>
    cnoremap <Char-0x7f>  <BS>
    ```
- keys for mappings
  - option 'insertmode' is off (default)
  - Default key action (0) Leader key
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |n   |```\```|not used|default leader key|
    |n   |```<Space>```|same as "l"|```let mapleader = "\<Space>"```|
    |n   |```<C-a>```|add N to number at/after cursor|
    |n   |```<C-b>```|scroll N screens Backwards|
    |n   |```<C-q>```|not used, or used for terminal control flow|
    > default tmux PREFIX is ```<C-b>```, default screen PREFIX is ```<C-a>```
    > customized tmux PREFIX is ```<C-q>```.
  - Default key action (1) b,f,a,e
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |i   |```<C-b>```|not used|This is default PREFIX for tmux.<br />```inoremap <C-b> h```|
    |i   |```<C-f>```|not used|```inoremap <C-f> l```|
    |i   |```<C-@>```|insert previously inserted text and stop insert|seldom use<br />```inoremap <C-@> <C-k>```|
    |i   |```<C-a>```|insert previously inserted text|seldom use<br />```inoremap <C-a> 0```|
    |i   |```<C-e>```|insert the character which is below the cursor|seldom use<br />```inoremap <C-e> $```|
    |n   |```<C-b>```|scroll N screens Backwards|This is default PREFIX for tmux.<br />```nnoremap <C-b> h```<br />alt: use ```<PageUp>```|
    |n   |```<C-f>```|scroll N screens Forward|```nnoremap <C-f> l```<br />alt: use ```<PageDown>```|
    |n   |```<C-@>```|not used|```nnoremap <C-@> <C-k>```|
    |n   |```<C-a>```|add N to number at/after cursor|seldom use<br />```nnoremap <C-a> 0```|
    |n   |```<C-e>```|scroll N lines upwards (N lines Extra)|seldom use<br />```nnoremap <C-e> $```|
  - Default key action (2) h,j,k,l or h,j,k,l,d,u
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |i   |```<C-h>```|same as <BS>|```inoremap <C-h> <Left>```<br />alt: ```inoremap <Char-127> <BR>```|
    |i   |```<C-j>```|same as <CR>|```inoremap <C-j> <Down>```|
    |i   |```<C-k>```|enter digraph|```inoremap <C-k> <Up>```<br />alt: ```inoremap <C-@> <C-k>```|
    |i   |```<C-l>```|~~when 'insertmode' set: Leave Insert mode~~|```inoremap <C-k> <Right>```|
    |i   |```<C-d>```|delete one shiftwidth of indent in the current line||
    |i   |```<C-u>```|delete all entered characters in the current line|use ```"_dd``` or ```0d$```|
    |n   |```<C-h>```|same as "h"|```nnoremap <C-h> <Left>```|
    |n   |```<C-j>```|same as "j"|```nnoremap <C-j> <Down>```|
    |n   |```<C-k>```|not used|```nnoremap <C-k> <Up>```|
    |n   |```<C-l>```|redraw screen|```nnoremap <C-k> <Right>```<br />alt: ```nnoremap <Leader><C-l> <C-l>```|
    |n   |```<C-d>```|scroll Down N lines (default: half a screen)|use ```<PageDown>```|
    |n   |```<C-u>```|scroll N lines Upwards (default: half a screen)|use ```<PageUp>```|
  - Default key action (3) as for ```<C-\> ...```
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |i   |```<C-\><C-n>```|go to Normal mode||
    |i   |```<C-\><C-g>```|~~go to mode specified with 'insertmode'~~||
    |i   |```<C-\> a-z```|reserved for extentions||
    |i   |```<C-\> others```|not used|```inoremap <C-\><C-\> <ESC>```|
    |n   |```<C-\><C-n>```|go to Normal mode (no-op)||
    |n   |```<C-\><C-g>```|~~go to mode specified with 'insertmode'~~||
    |n   |```<C-\> a-z```|reserved for extentions||
    |n   |```<C-\> others```|not used|```nnoremap <C-\><C-\> <ESC>```<br />```vnoremap <C-\><C-\> <ESC>```|
  - Default key action (4) as for ```<ESC>```
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |i   |```<C-[>```|same as <Esc>||
    |i   |```<ESC>```|end insert mode ~~(unless 'insertmode' set)~~||
    |n   |```<C-[>```|not used|Do not map for repeating.|
    |n   |```<ESC>```|not used|Do not map. Map ```<ESC>``` will break other maps.|
  - Default key action (5) Command-line editing mode
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |c   |```<C-o>```|not used||
    |c   |```<C-b>```|cursor to begin of command-line|```cnoremap <C-b> <Left>```|
    |c   |```<C-f>```|default value for 'cedit':<br />opens the command-line window;<br /> otherwise not used|```cnoremap <C-f> <Right>```|
    |c   |```<C-@>```|not used|```cnoremap <C-@> <C-k>```|
    |c   |```<C-a>```|do completion on the pattern in front of the cursor and insert all matches|```cnoremap <C-a> <Home>```|
    |c   |```<C-e>```|cursor to end of command-line|as is, or ```cnoremap <C-e> <End>```|
    |c   |```<C-h>```|same as <BS>|use ```<BS>```<br />```cnoremap <C-h> <Left>```|
    |c   |```<C-j>```|same as <CR>|use ```<CR>```<br />```cnoremap <C-j> <nop>```|
    |c   |```<C-k>```|enter digraph|```cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>```<br />(remove all characters after cursor)<br />alt: ```cnoremap <C-@> <C-k>```|
    |c   |```<C-l>```|do completion on the pattern in front of the cursor and insert the longest common part|seldom use<br />```cnoremap <C-l> <Right>```|
    |c   |```<C-d>```|list completions that match the pattern in front of the cursor|seldom use<br />```cnoremap <C-d> <Del>```|
    |c   |```<C-u>```|remove all characters (BEFORE CURSOR)|as is|
    |c   |```<C-\><C-n>```|go to Normal mode,<br />abandon command-line||
    |c   |```<C-\><C-g>```|~~go to mode specified with 'insertmode',<br />abandon command-line~~||
    |c   |```<C-\> a-d```|reserved for extentions||
    |c   |```<C-\>e {expr}```|replace the command line with the result of {expr}||
    |c   |```<C-\> f-z```|reserved for extentions||
    |c   |```<C-\> others```|not used|```cnoremap <C-\><C-\> <ESC>```|
    > in Command-line editing mode, bash key-map is useful.
    > |key|action|vim key| Command-line editing mode mapping |
    > |:-:|:-----|:------|:----|
    > |```<C-b>```|backward-char<br />Move back a character.| ```<Left>``` | ```cnoremap <C-b> <Left>``` |
    > |```<C-f>```|forward-char<br />Move forward a character.| ```<Right>``` | ```cnoremap <C-f> <Right>``` |
    > |```<C-a>```|beginning-of-line<br />Move to the start of the current line.| ```<Home>``` | ```cnoremap <C-a> <Home>``` |
    > |```<C-e>```|end-of-line<br />Move to the end of the line.| ```<End>``` | ```cnoremap <C-e> <End>``` |
    > |```<C-d>```|delete-char<br />Delete the character at point.| ```"_x``` | ```cnoremap <C-d> <Del>``` |
    > |```<C-u>```|unix-line-discard<br />Kill backward from point to the beginning of the line.| ```"_d0``` | as is |
    > |```<C-k>```|kill-line<br />Kill the text from point to the end of the line.| ```"_d$``` | ```cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>``` |
  
- keys for mappings
  - F1, F2 Help/Show register and Recording/Executing macro
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |n   |```<F1>```|toggle help<br />```nnoremap <F1> :call <SID>ToggleHelp()<CR>```||
    |n   |```<F2>```|show register<br />```nnoremap <F2> :<C-u>reg<CR>```||
    |n   |```<S-F1>```|record typed characters into named register a<br />```nnoremap <S-F1> :<C-u>call <SID>AltRecord('a', 4)<CR>```||
    |n   |```<S-F2>```|execute register<br />```nnoremap <S-F2> @a```||
    |n   |```<C-F1>```|record typed characters into named register a<br />```nnoremap <C-F1> :<C-u>call <SID>AltRecord('b', 4)<CR>```||
    |n   |```<C-F2>```|execute register<br />```nnoremap <C-F2> @b```||
    |n   |```<C-S-0F1>```|record typed characters into named register a<br />```nnoremap <C-S-F1> :<C-u>call <SID>AltRecord('c', 6)<CR>```||
    |n   |```<C-S-0F2>```|execute register<br />```nnoremap <C-S-F2> @c```||
    |iv  |```<F1>```|show information about current cursor position<br />```inoremap <F1> <ESC>g<C-g>```<br />```vnoremap <F1> <ESC>g<C-g>```||
    |iv  |```<F2>```|```inoremap <F2> <nop>```<br />```vnoremap <F2> <nop>```||
    > ```nnoremap <S-F1> :<C-u>call <SID>AltRecord('x', 4)<CR>```
    > ```nnoremap <C-S-F1> :<C-u>call <SID>AltRecord('x', 6)<CR>```
    > ```nnoremap <M-C-S-F1> :<C-u>call <SID>AltRecord('x', 8)<CR>```
  - ToggleHelp
    ```console
    """ F1 toggle Help
    nnoremap <F1> :call <SID>ToggleHelp()<CR>
    """ function for F1, toggle Help
    function! s:ToggleHelp()
      if &buftype == "help"
        exec 'quit'
      else
        exec 'help'
      endif
    endfunction
    ```
  - AltRecord
    ```console
    """ Function: AltRecord
    "     Parameters:
    "       reg
    "         register name, e.g. 'a' means register @a
    "       len
    "         remove characters length.
    "     Usage:
    "         nnoremap <S-F1> :<C-u>call <SID>AltRecord('a', 4)
    "         nnoremap <S-F2> :<C-u>call <SID>AltRecord('b', 4)
    function! s:AltRecord(reg, len)
      if exists("g:recording_macro")
        let r = g:recording_macro
        unlet g:recording_macro
        normal! q
        execute 'let @'.r." = @".r.'[:-'.a:len.']'
        echo 'recorded. Type @'.r.' to run the macro.'
      else
        let g:recording_macro = a:reg
        execute 'normal! q'.a:reg
      endif
    endfunction
    ```
  - F3, F4 search and replace
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |n   |```<F3>```    |search next<br />```nnoremap <F3> n```||
    |n   |```<S-F3>```  |search previous<br />```nnoremap <S-F3> N```||
    |n   |```<C-F3>```  |confirm search next<br />```nnoremap <C-F3> /<C-r>"```||
    |n   |```<C-S-F3>```|confirm search previous<br />```nnoremap <C-S-F3> ?<C-r>"```||
    |n   |```<F4>```    |replace again<br />```nnoremap <F4> &```|repeat replace with ```<F3><F4>```|
    |n   |```<S-F4>```  |replace again<br />```nnoremap <S-F4> &```|repeat replace with```<S-F3><S-F4>```|
    |n   |```<C-F4>```  |confirm replace<br />```nnoremap <C-F4> :s/<C-r>"//gc<Left><Left><Left>```||
    |n   |```<C-S-F4>```|confirm replace<br />```nnoremap <C-S-F4> :s#<C-r>"##gc<Left><Left><Left>```||
    |v   |```<F3>```    |search next<br />```vnoremap <F3> n```||
    |v   |```<S-F3>```  |search previous<br />```vnoremap <S-F3> N```||
    |v   |```<C-F3>```  |confirm search<br />```vnoremap <C-F3> /<C-r>"```||
    |v   |```<C-S-F3>```|confirm search<br />```vnoremap <C-S-F3> ?<C-r>"```||
    |v   |```<F4>```    |replace again<br />```vnoremap <F4> &```||
    |v   |```<S-F4>```  |replace again<br />```vnoremap <S-F4> &```||
    |v   |```<C-F4>```  |confirm replace<br />```vnoremap <C-F4> :s/<C-r>"//gc<Left><Left><Left>```||
    |v   |```<C-S-F4>```|confirm replace<br />```vnoremap <C-S-F4> :s#<C-r>"##gc<Left><Left><Left>```||
    |i   |```<F3>```    |search next<br />```inoremap <F3> <C-o>n```||
    |i   |```<S-F3>```  |search previous<br />```inoremap <S-F3> <C-o>N```||
    |i   |```<C-F3>```  |confirm search<br />```inoremap <C-F3> <C-o>/<C-r>"```||
    |i   |```<C-S-F3>```|confirm search<br />```inoremap <C-S-F3> <C-o>?<C-r>"```||
    |i   |```<F4>```    |replace again<br />```inoremap <F4> <C-o>&```||
    |i   |```<S-F4>```  |replace again<br />```inoremap <S-F4> <C-o>&```||
    |i   |```<C-F4>```  |confirm replace<br />```inoremap <C-F4> <C-o>:s/<C-r>"//gc<Left><Left><Left>```||
    |i   |```<C-S-F4>```|confirm replace<br />```inoremap <C-S-F4> <C-o>:s#<C-r>"##gc<Left><Left><Left>```||
     
  
### Usage
- 1. mode
  - (1) NORMAL mode
    - just after starting vim, initial mode is NORMAL mode. 
      > when option 'insertmode' is off (default).
    - you can back into NORMAL mode with ```<ESC>``` or ```<C-[>``` (may require several times)
    - in NORMAL mode, each key input is interpreted as a command.
  - (2) INSERT mode
    - in INSERT mode, all string key input is interpreted as text input.
    - to enter INSERT mode from NORMAL mode, type
      - &#8203;```i``` (input) : start INSERT mode. (input text at cursor position)
      - &#8203;```I``` (Input) : move cursor at beginning of the line and starts INSERT mode.
      - &#8203;```a``` (append) : move cursor RIGHT by one CHAR and start INSERT mode. (append text after cursor position)
      - &#8203;```A``` (Append) : move cursor at the end of the line and start INSERT mode.
      - &#8203;```o``` (open) : add a new line below the cursor position and start INSERT mode.
      - &#8203;```O``` (Open) : add a new line above the cursor position and start INSERT mode.
    - type ```<ESC>``` or ```<C-[>``` to back into NORMAL mode.
    - some of the famouse commands are cursor move commands and put(paste) command.
      - &#8203;```h``` moves cursor LEFT.
      - &#8203;```j``` moves cursor DOWN.
      - &#8203;```k``` moves cursor UP.
      - &#8203;```l``` moves cursor RIGHT.
      - &#8203;```p``` put(paste) yanked text at cursor position.
      - &#8203;```P``` put(paste) yanked text after cursor position.
  - (3) VISUAL mode
    - in VISUAL mode, cursor move changes selection region. you can yank(copy), delete(cut), and so on.
    - to enter INSERT mode from NORMAL mode, type
      - &#8203;```v``` (VISUAL) : start characterwise Visual mode.
      - &#8203;```V``` (LINE VISUAL) : start linewise Visual mode.
      - &#8203;```<C-v>``` (BLOCK VISUAL) : start blockwise Visual mode.
    - type ```<ESC>``` or ```<C-[>``` to back into NORMAL mode.
    - some of the famouse commands are yank command and delete command.
      - &#8203;```y``` will copy selected textand save into register ```""```. You can put(paste) it with ```p``` (or ```P```) in NORMAL mode.
      - &#8203;```d``` will delete selected text and save into register ```""```.
  - (4) Command editing mode
    - in Command editing mode, all string key input is interpreted as command text input.
    - to enter Command editing mode from NORMAL mode, type
      - &#8203;```:``` start entering an Ex command. you should enter command and press ```<CR>``` to execute the command.
    - type ```<ESC>``` or ```<C-[>``` to back into NORMAL mode.
      - if you delete ```:``` shown in status line with Backspace key, leaves from Command editing mode.
    - the most famouse command is substitute.
      - &#8203;```:s/abc/XYZ/``` will substitute ```abc``` to ```XYZ``` once on cursor line.
      - &#8203;```:s#abc#XYZ#``` will substitute ```abc``` to ```XYZ``` once on cursor line.
        > separater char (just after 's') can be '/', '#', '$', ':', '@', '%' and so on...
  - (5) Operator pending mode (skip if beginner)
    - Operator pending mode is just after pressing ```operator``` (```d```, ```y```, ```c``` etc...) command and before ```{motion}```.
    - type ```<ESC>``` or ```<C-[>``` to back into NORMAL mode.
      - if you delete operator (may be shown in status line) with Backspace key, leaves from Operator pending mode.
- 2. cursor move
  - (1) Left, Down, Up, Right
    - ```<Left>```. ```<Down>```, ```<Up>```, ```<Right>```
    - ```h```. ```j```, ```k```, ```l```
    - customize
      - ```<C-h>```. ```<C-j>```, ```<C-k>```, ```<C-l>```
  - (2) begin / end of the line
    - ```<Home>```. ```<End>```
    - ```0```. ```$```, ```^```, ```g_```
    - customize
      - ```<C-a>```. ```<C-e>```
  - (3) page
    - ```<PageUp>```. ```<PageDown>```
    - ```C-f```, ```C-b``` (One page)
    - ```C-u```. ```C-d``` (Half a page)
  - (4) file
    - ```gg```. ```G```
    - ```{num}gg```, ```{num}G```
    - customize
      - ```<C-Home>```. ```<C-End>```
- 3. copy & paste
  - most useful 
    - ```yy``` (yank line into register "")
    - ```dd``` (delete line into register "")
    - ```p``` (put from register "")
    - ```w``` (word), ```W``` (WORD)
    - ```e``` (end of word), ```E``` (end of WORD)
    - ```b``` (beginning of word), ```B``` (beginning of WORD)
  - copy in VISUAL mode
    - ```v``` (VISUAL mode) ... cursor move (select region) ... ```y``` (yank into register "")
    - ```v``` (VISUAL mode) ... cursor move (select region) ... ```"py``` (yank into register "p)
  - cut in VISUAL mode
    - ```v``` (VISUAL mode) ... cursor move (select region) ... ```d``` (delete into register "")
    - ```v``` (VISUAL mode) ... cursor move (select region) ... ```"pd``` (delete into register "p)
  - copy in NORMAL mode
    - ```yiw``` (yank inner word), ```yiW``` (yank inner WARD)
    - ```yaw``` (yank a word), ```yaW``` (yank a WARD)
    - [Text objects](https://vim-jp.org/vimdoc-en/vimindex.html#objects)
      - ```i'``` single quoted string without the quotes, ```a'``` single quoted string
      - ```i"``` double quoted string without the quotes, ```a"``` double quoted string
      - ```ib``` inner block (from ```[{``` to ```]}```), ```ab``` a block, ```aB``` a Block
      - ```is``` inner sentence, ```as``` a sentence
      - and so on ...
      > ```i``` means 'inner', ```a``` means 'a' (or 'around'?)
  - paste in NORMAL mode
    - ```p``` (put: after cursor from register ""), ```P``` (Put: at cursor from register "")
    - ```"pp``` (put register "p), ```"pP``` (Put register "p)
  - cut in NORMAL mode
    - ```diw``` (delete inner word into register ""), ```diW``` (delete inner WARD into register "")
    - ```daw``` (delete a word into register ""), ```daW``` (delete a WARD into register "")
    - ```"pdiw``` (delete inner word into register "p), ```"pdiW``` (delete inner WARD into register "p)
    - ```"pdaw``` (delete a word into register "p), ```"pdaW``` (delete a WARD into register "p)
    - ```"_diw``` (delete inner word into blackhole register), ```"_diW``` (delete inner WARD into blackhole register)
    - ```"_daw``` (delete a word into blackhole register), ```"_daW``` (delete a WARD into blackhole register)
  - in NORMAL mode, ```{operator}``` like ```c```, ```y```, ```d```　waits for ```{motion}``` like ```w```, ```e```, ```b``` (or Text objects)
  - in VISAL mode, ```{motion}``` changes selected region, and ```{operator}``` works on selected text
- 4. Window & tab
  - window
    - ```:sp``` (split up and down), ```:vs``` (split left and right)
    - ```:q``` (close window)
    - ```<C-w>w``` or ```<C-w><C-w>``` (next window), ```<C-w>W``` (previous window)
    - ```<C-w>r``` or ```<C-w><C-r>``` (rotate window downwards), ```<C-w>R``` (rotate window upwards)
  - tab
    - ```:tabn``` (tab new)
    - ```:q``` (close tab)
    - ```gt``` or ```<C-PageDown>``` (next tab), ```gT``` or ```<C-PageUp>``` (previous tab)
- 5. mark
  - ```mm``` (set mark m), ```mn``` (set mark n), ```m{A-Za-z}``` (set mark ```{A-Za-z}``` at cursor position)
  - ``` `m``` or ```'m``` (cursor to mark m), ``` `n``` or ```'n``` (cursor to mark n)
  - ``` `]``` (cursor to next lowercase mark), ``` `[``` (cursor to previous lowercase mark)

### Customize
- 1. options
- 2. key bindings
- 3. Leader
- 4. Key code

### keycode check
- キーコードをチェックするための定義  
  以下を.vimrcの末尾に貼り付けて、動作確認する。  
  ただし、カーソル移動にカーソルキーが使えなくなるので、hjklを使う、ggやGを使う、インサートモードに移行してカーソルキーを使う。
  ```console
  nnoremap <Up>         :echo 'nnoremap Up'<CR>
  nnoremap <S-Up>       :echo 'nnoremap S-Up'<CR>
  nnoremap <Down>       :echo 'nnoremap Down'<CR>
  nnoremap <S-Down>     :echo 'nnoremap S-Down'<CR>
  nnoremap <Right>      :echo 'nnoremap Right'<CR>
  nnoremap <S-Right>    :echo 'nnoremap S-Right'<CR>
  nnoremap <Left>       :echo 'nnoremap Left'<CR>
  nnoremap <S-Left>     :echo 'nnoremap S-Left'<CR>
  nnoremap <PageUp>     :echo 'nnoremap PageUp'<CR>
  nnoremap <S-PageUp>   :echo 'nnoremap S-PageUp'<CR>
  nnoremap <PageDown>   :echo 'nnoremap PageDown'<CR>
  nnoremap <S-PageDown> :echo 'nnoremap S-PageDown'<CR>
  nnoremap <Home>       :echo 'nnoremap Home'<CR>
  nnoremap <S-Home>     :echo 'nnoremap S-Home'<CR>
  nnoremap <End>        :echo 'nnoremap End'<CR>
  nnoremap <S-End>      :echo 'nnoremap S-End'<CR>
  nnoremap <Insert>     :echo 'nnoremap Insert'<CR>
  nnoremap <S-Insert>   :echo 'nnoremap S-Insert'<CR>
  nnoremap <Delete>     :echo 'nnoremap Delete'<CR>
  nnoremap <S-Delete>   :echo 'nnoremap S-Delete'<CR>
  nnoremap <F1>         :echo 'nnoremap F1'<CR>
  nnoremap <S-F1>       :echo 'nnoremap S-F1'<CR>
  nnoremap <F2>         :echo 'nnoremap F2'<CR>
  nnoremap <S-F2>       :echo 'nnoremap S-F2'<CR>
  nnoremap <F3>         :echo 'nnoremap F3'<CR>
  nnoremap <S-F3>       :echo 'nnoremap S-F3'<CR>
  nnoremap <F4>         :echo 'nnoremap F4'<CR>
  nnoremap <S-F4>       :echo 'nnoremap S-F4'<CR>
  nnoremap <F5>         :echo 'nnoremap F5'<CR>
  nnoremap <S-F5>       :echo 'nnoremap S-F5'<CR>
  nnoremap <F6>         :echo 'nnoremap F6'<CR>
  nnoremap <S-F6>       :echo 'nnoremap S-F6'<CR>
  nnoremap <F7>         :echo 'nnoremap F7'<CR>
  nnoremap <S-F7>       :echo 'nnoremap S-F7'<CR>
  nnoremap <F8>         :echo 'nnoremap F8'<CR>
  nnoremap <S-F8>       :echo 'nnoremap S-F8'<CR>
  nnoremap <F9>         :echo 'nnoremap F9'<CR>
  nnoremap <S-F9>       :echo 'nnoremap S-F9'<CR>
  nnoremap <F10>        :echo 'nnoremap F10'<CR>
  nnoremap <S-F10>      :echo 'nnoremap S-F10'<CR>
  nnoremap <F11>        :echo 'nnoremap F11'<CR>
  nnoremap <S-F11>      :echo 'nnoremap S-F11'<CR>
  nnoremap <F12>        :echo 'nnoremap F12'<CR>
  nnoremap <S-F12>      :echo 'nnoremap S-F12'<CR>
  ```

      
