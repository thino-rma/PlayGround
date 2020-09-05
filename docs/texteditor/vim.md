### about key mapping
- URL
  - [vim index JP](https://vim-jp.org/vimdoc-ja/vimindex.html)
  - [vim index EN](https://vim-jp.org/vimdoc-en/vimindex.html)

- Default key mapping for Cursor move
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
    |i  |```<C-h>```|same as <BS>|```inoremap <C-h> <Left>```|
    |i  |```<C-j>```|same as <CR>|```inoremap <C-j> <Down>```|
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
    
