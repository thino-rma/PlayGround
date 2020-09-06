### about key mapping
- URL
  - [vim index JP](https://vim-jp.org/vimdoc-ja/vimindex.html)
  - [vim index EN](https://vim-jp.org/vimdoc-en/vimindex.html)
- RLogin側の設定
  - 制御コード
    - 「?67 Set BSキーでBSを送信 / Reset BSキーでDELを送信」のチェックをはずす
      > チェックが入っていると、 BSキーで ```^h```（これは C-h とかぶる） を送信する。チェックを外すと、BSキーで ```^?``` を送信する。
      > 目的：vimで、BSキーと C-h を別々にマッピングするのに必要。
  - キーコード
    - 「1.modifyCursorKeys」を、「UP,DOWN,RIGHT,LEFT,PRIOR,NEXT,HOME,END,DELETE」（INSERTを除く）に対して「0」を設定。
      > 注意：INSERTを除いていることに注意する。これは、RLogin のショートカットに Shift-Insert を $PASTE にマッピングしているため。
      > 目的：vimで、カーソルキーなどのキーに機能を割り付けるとき、修飾コードを追加することで、使いやすくする。
    - 「2.modifyCursorKeys」を、「F1-F12」（デフォルト）に対して「0」を設定。
      > 目的：vimで、ファンクションキーに機能を割り付けるとき、修飾コードを追加することで、使いやすくする。
    - 「3.modifyKeypadKeys」を、「PAD0-PAD9,PADMUL,PADADD,PADSEP,PADSUB,PADDEC,PADDIV」（デフォルト）に対して「0」を設定。
      > 「-1」（デフォルト）の場合、Ctrlとキーパッドの「-」を入力すると、RLoginの挙動が不安定になった。（接続が応答しなくなる）
      > 「0」にした場合、Ctrlとキーパッドの「-」を入力しても、RLoginの挙動が不安定にならない。
      > vimの割り付けには使用しない。
    - 「4.modifyOtherKeys」を、「ESCAPE,RETURN,BACK,TAB」（デフォルト）に対して「-1」（デフォルト）を設定。
      > vimの割り付けには使用しない。
    - 「5.modifyStringKeys」を、「SPACE,0-9,A-Z」（デフォルト）に対して「-1」（デフォルト）を設定。
      > vimの割り付けには使用しない。
    - 「modifyKeysがメニューのショートカットキー設定より優先する」にチェックを入れる。
      > 目的：RLogin のショートカットをできる限り無効にしたいため。（RLoginでペイン分割などしたくない）
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
    |i  |```<C-l>```|when 'insertmode' set: Leave Insert mode|```inoremap <C-l> <Right>```<br />```inoremap jj <ESC>```|
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
  - Default key action (0) 
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |n   |```<Space>```|same as "l"||
    |n   |```\```|not used||
    |c   |```<C-o>```|not used||
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
    |c   |```<C-b>```|cursor to begin of command-line|```cnoremap <C-b> <Left>```|
    |c   |```<C-f>```|default value for 'cedit':<br />opens the command-line window;<br /> otherwise not used|```cnoremap <C-f> <Right>```|
    |c   |```<C-@>```|not used|```cnoremap <C-@> <C-k>```|
    |c   |```<C-a>```|do completion on the pattern in front of the cursor and insert all matches|```cnoremap <C-a> <Home>```|
    |c   |```<C-e>```|cursor to end of command-line|as is, or ```cnoremap <C-e> <End>```|
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
    |c   |```<C-h>```|same as <BS>|use ```<BS>```<br />```cnoremap <C-h> <Left>```|
    |c   |```<C-j>```|same as <CR>|use ```<CR>```<br />```cnoremap <C-j> <nop>```|
    |c   |```<C-k>```|enter digraph|```cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>```<br />(remove all characters after cursor)<br />alt: ```cnoremap <C-@> <C-k>```|
    |c   |```<C-l>```|do completion on the pattern in front of the cursor and insert the longest common part|seldom use<br />```cnoremap <C-l> <Right>```|
    |c   |```<C-d>```|list completions that match the pattern in front of the cursor|seldom use<br />```cnoremap <C-d> <Del>```|
    |c   |```<C-u>```|remove all characters (BEFORE CURSOR)|as is|
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
    |c   |```<C-\><C-n>```|go to Normal mode,<br />abandon command-line||
    |c   |```<C-\><C-g>```|~~go to mode specified with 'insertmode',<br />abandon command-line~~||
    |c   |```<C-\> a-d```|reserved for extentions||
    |c   |```<C-\>e {expr}```|replace the command line with the result of {expr}||
    |c   |```<C-\> f-z```|reserved for extentions||
    |c   |```<C-\> others```|not used|```cnoremap <C-\><C-\> <ESC>```|
  - Default key action (4) as for ```<ESC>```
    |mode|key|action|memo|
    |:--:|:--|:-----|:---|
    |i   |```<C-[>```|same as <Esc>||
    |i   |```<ESC>```|end insert mode ~~(unless 'insertmode' set)~~||
    |n   |```<C-[>```|not used|Do not map for repeating.|
    |n   |```<ESC>```|not used|Do not map. Map ```<ESC>``` will break other maps.|

                                
  
