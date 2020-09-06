" $ curl https://raw.githubusercontent.com/thino-rma/PlayGround/master/shell/.vimrc -L -o ~/.vimrc
" $ wget https://raw.githubusercontent.com/thino-rma/PlayGround/master/shell/.vimrc -O ~/.vimrc

""" this option is useless.
set nocompatible

"=== for vim.tiny ======================================================

""" ambiguas character width
set ambiwidth=double

set autowrite      " Automatically save before commands like :next and :make

""" enable backspace
set backspace=indent,eol,start

set expandtab      " expand tab to whitespace

""" encoding
set encoding=utf-8

set hidden         " Hide buffers when they are abandoned
set ignorecase     " Do case insensitive matching
set incsearch      " Incremental search
" set list           " show unvisible character

""" list characters
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

""" number format : this affects C-a (increment), C-x (decrement)
set nrformats-=octal,hex

" set number         " Show line number

""" set indent size
set shiftwidth=4
set showmatch      " Show matching brackets.
set smartcase      " Do smart case matching

""" set tab size
set tabstop=4

""" set terminal visual bell off
set vb t_vb=

""" if vim.tiny then execute it.
silent! while 0
  noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>
  """ finish reading vimrc
  finish
silent! endwhile

" DON'T ERASE this!!
if 1
"=== for vim ===========================================================

set background=dark
set clipboard=unnamedplus
" set cursorline
" set cursorcolumn
set history=50
set hlsearch
set laststatus=1
set scrolloff=5
set showcmd
" set smartindent
set t_Co=256
set textwidth=0
set title
set virtualedit=block
set whichwrap=b,s,[,],<,>
set wildmenu
set wildmode=list:longest

filetype plugin indent on
syntax on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" IME control
" https://qiita.com/U25CE/items/0b40662a22162907efae
" start INSERT mode, IME on
execute "set t_SI+=\<Esc>[<r"
" exit INSERT mode, IME mode save, IME off
execute "set t_EI+=\<Esc>[<s\<ESC>[<0t"
" terminate, IME off
execute "set t_te+=\<Esc>[<0t\<ESC>[<s"
" The time in milliseconds that is waited for a key code or mapped key sequence to complete.
set ttimeoutlen=100

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" input wrapper function
function! s:input(...) abort
  new
  cnoremap <buffer> <Esc> __CANCELED__<CR>
  let ret = call('input', a:000)
  bwipeout!
  redraw
  if ret =~# '__CANCELED__$'
    throw 'Canceled'
  endif
  return ret
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Override default key mapping.
"(Avoid as much as possible. Use <Leader> instead.)

" using blackhole register
nnoremap x "_x
vnoremap x "_x

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" key-maps for Cursor-move
""" for Ctrl-h,j,k,l
nnoremap <C-h> <Left>
vnoremap <C-h> <Left>
inoremap <C-h> <Left>
nnoremap <C-j> <Down>
vnoremap <C-j> <Down>
inoremap <C-j> <Down>
nnoremap <C-l> <Right>
vnoremap <C-l> <Right>
inoremap <C-l> <Right>
nnoremap <C-k> <Up>
vnoremap <C-k> <Up>
inoremap <C-k> <Up>

" for RLogin, BS generates ^H, which is same as <C-h>
" so you will lose BS key functionality with the settings above
" like "inoremap <C-h> <Left>".
" set Screen -> ControlCode -> Escape sequence
"     No.?67 Unchecked (Reset - Send DEL with BS key)
" this makes key code for Back(BackSpace) ^? (= 127 = 0x7f)
" and BS key <Char-0x7f> can be mapped as you like.
nnoremap <Char-0x7f>  <Left>
vnoremap <Char-0x7f>  <Left>
inoremap <Char-0x7f>  <BS>
cnoremap <Char-0x7f>  <BS>

" alternative key for Normal mode <C-l> redraw screen
"   nnoremap <Leader><C-l> <C-l>
" alternative key for Insert mode <C-k> enter digraph
"   inoremap <F7> <C-k>
" alternative key for Insert mode <C-l> Leave Insert mode
"   use default <C-[>      in Insert mode : Leave Insert mode
"   use default <C-\><C-n> in Insert mode : Go to Normal mode

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" keymaps for <ESC> in Insert mode
" use default Ctrl-[ in Insert mode

inoremap jj <ESC>

" default <C-i>      in Insert mode : same as <Tab>
vnoremap <C-i>      <ESC>
inoremap <C-i>      <ESC>
cnoremap <C-i>      <ESC>
" default <C-\><C-\> in Insert mode : not used
vnoremap <C-\><C-\> <ESC>
inoremap <C-\><C-\> <ESC>
cnoremap <C-\><C-\> <ESC>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" key-maps for comandline-edit

" <C-b> cursor to left
" <C-f> cursor to right
" <C-a> cursor to begin of command-line
" <C-e> cursor to end of command-line
" <C-d> delete character under the cursor
" <C-u> Remove all characters between the cursor position and the beginning of the line.
" <C-k> Remove all characters between the cursor position and the end of the line.
" <C-r>{regname} 
"       insert the contents of a register under the cursor as if typed

""" backups
cnoremap <C-\>1 <C-a>
cnoremap <C-\>2 <C-b>
cnoremap <C-\>3 <C-d>
cnoremap <C-\>4 <C-f>
" enter digraph    <C-@>{char1}{char2} = <F7>{char1}{cahr2}
cnoremap <C-@>  <C-k>

cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-a> <Home>
cnoremap <C-k> <C-\>e(fstrpart(getcmdline(), 0, getcmdpos() - 1))<CR>
cnoremap <C-d> <Del>

" enter digraph    <F7>{char2} = <C-k>j{char2}
cnoremap <F7>  <C-k>j

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" you may have to set keycode for F1: type i (insert mode), type C-v, type F1.
execute "set      <xF1>=\<Esc>[11;*~"
execute "set      <xF2>=\<Esc>[12;*~"
execute "set      <xF3>=\<Esc>[13;*~"
execute "set      <xF4>=\<Esc>[14;*~"
execute "set       <F5>=\<Esc>[15;*~"
execute "set       <F6>=\<Esc>[17;*~"
execute "set       <F7>=\<eSc>[18;*~"
execute "set       <F8>=\<Esc>[19;*~"
execute "set       <F9>=\<Esc>[20;*~"
execute "set      <F10>=\<Esc>[21;*~"
execute "set      <F11>=\<Esc>[23;*~"
execute "set      <F12>=\<Esc>[24;*~"
execute "set   <Insert>=\<Esc>[2;*~"
execute "set      <Del>=\<Esc>[3;*~"
execute "set    <xHome>=\<Esc>O*H"
execute "set     <xEnd>=\<Esc>O*F"
execute "set   <PageUp>=\<Esc>[5;*~"
execute "set <PageDown>=\<Esc>[6;*~"
execute "set      <xUp>=\<Esc>O*A"
execute "set    <xDown>=\<Esc>O*B"
execute "set   <xRight>=\<Esc>O*C"
execute "set    <xLeft>=\<Esc>O*D"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F1  Help / recording macros

""" F1 <Esc>, show information about current cursor position
vnoremap <F1> <Esc>g<C-g>
inoremap <F1> <Esc>g<C-g>

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

""" start/finish recording with Shift+F12 to register
nnoremap <S-F1>      :<C-u>call <SID>AltRecord('a', 4)<CR>
nnoremap <M-F1>      :<C-u>call <SID>AltRecord('b', 8)<CR>
nnoremap <M-S-F1>    :<C-u>call <SID>AltRecord('c', 8)<CR>
nnoremap <C-F1>      :<C-u>call <SID>AltRecord('d', 8)<CR>
nnoremap <C-S-F1>    :<C-u>call <SID>AltRecord('e', 8)<CR>
nnoremap <M-C-F1>    :<C-u>call <SID>AltRecord('f', 8)<CR>
nnoremap <M-C-S-F1>  :<C-u>call <SID>AltRecord('g', 8)<CR>

inoremap <S-F1>      <C-o>:call <SID>AltRecord('a', 4)<CR>
inoremap <M-F1>      <C-o>:call <SID>AltRecord('b', 4)<CR>
inoremap <M-S-F1>    <C-o>:call <SID>AltRecord('c', 6)<CR>
inoremap <C-F1>      <C-o>:call <SID>AltRecord('d', 4)<CR>
inoremap <C-S-F1>    <C-o>:call <SID>AltRecord('e', 6)<CR>
inoremap <M-C-F1>    <C-o>:call <SID>AltRecord('f', 6)<CR>
inoremap <M-C-S-F1>  <C-o>:call <SID>AltRecord('g', 8)<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F2  execute register
"     Hint: :reg shows register list, (use F2)

""" show register
nnoremap <F2>        :<C-u>reg<CR>
inoremap <F2>        <nop>
""" execute macro in register
nnoremap <S-F2>      @a
nnoremap <M-F2>      @b
nnoremap <M-S-F2>    @c
nnoremap <C-F2>      @d
nnoremap <C-S-F2>    @e
nnoremap <M-C-F2>    @f
nnoremap <M-C-S-F2>  @g

inoremap <expr> <S-F2>      @a
inoremap <expr> <M-F2>      @b
inoremap <expr> <M-S-F2>    @c
inoremap <expr> <C-F2>      @d
inoremap <expr> <C-S-F2>    @e
inoremap <expr> <M-C-F2>    @f
inoremap <expr> <M-C-S-F2>  @g

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F3  search commands.
"     without Shift, search forward
"     with    Shift, search backward
"     without Ctrl,  execute search
"     with    Ctrl,  confirm search (waiting for <CR>)
"     without Alt,   use register "/ (Last search pattern register)
"     with    Alt,   use register "" (unnamed register)
"     Hint: q/ and q? shows search history.

""" without modifier, search next
nnoremap <F3> n
vnoremap <F3> n
inoremap <F3> <C-o>n

""" with Shift, search previous
nnoremap <S-F3> N
vnoremap <S-F3> N
inoremap <S-F3> <C-o>N

""" with Alt, search forward, using "" (unnamed)
nnoremap <M-F3> /<C-r>"<CR>
vnoremap <M-F3> /<C-r>"<CR>
inoremap <M-F3> <C-o>/<C-r>"<CR>

""" with Alt-Shift, search backword, using "" (unnamed)
nnoremap <M-S-F3> ?<C-r>"<CR>
vnoremap <M-S-F3> ?<C-r>"<CR>
inoremap <M-S-F3> <C-o>?<C-r>"<CR>

""" with Ctrl, confirm search forward, waiting for <CR>
"   if IME ON, use just /.
nnoremap <C-F3> /<C-r>/
vnoremap <C-F3> /<C-r>/
inoremap <C-F3> <C-o>/<C-r>/

""" with Ctrl-Shift, confirm search backward, waiting for <CR>
"   if IME ON, use just ?.
nnoremap <C-S-F3> ?<C-r>/
vnoremap <C-S-F3> ?<C-r>/
inoremap <C-S-F3> <C-o>?<C-r>/

""" with Alt-Ctrl, confirm search forward, using "" (unnamed), waiting for <CR>
nnoremap <M-C-F3> /<C-r>"
vnoremap <M-C-F3> /<C-r>"
inoremap <M-C-F3> <C-o>/<C-r>"

""" with Alt-Ctrl-Shift, confirm search backword, using "" (unnamed), waiting for <CR>
nnoremap <M-C-S-F3> ?<C-r>"
vnoremap <M-C-S-F3> ?<C-r>"
inoremap <M-C-S-F3> <C-o>?<C-r>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F4  substitute commands.
"     F4 and Shift-F4 is same mapping, just repeat substitute.
"     others
"       without Shift, substitute with separater /
"       with    Shift, substitute with separater #
"       without Ctrl,  execute substitute with ~ ({string} of the previous substitute)
"       with    Ctrl,  confirm substitute with ~ (waiting for <CR>)
"       without Alt,   use register "/ (Last search pattern register)
"       with    Alt,   use register "" (pattern)
"     Hint: q: shows command history (includes substitute).

""" without modifire, repeat last substitute
"   so that you can use F3 and F4 repeatedly.
""" without modifire, repeat last substitute
"   so that you can use F3 and F4 repeatedly.
nnoremap <F4> &
vnoremap <F4> <nop>
inoremap <F4> <C-o>&

""" with Shift, repeat last substitute
"   so that you can use F3 and F4 repeatedly.
nnoremap <S-F4> &
vnoremap <S-F4> <nop>
inoremap <S-F4> <C-o>&

""" with Alt, substitute /, using from  "" to previous {string}
nnoremap <M-F4> :s/<C-r>"/~/<CR>
vnoremap <M-F4> <nop>
inoremap <M-F4> <C-o>:s/<C-r>"/~/<CR>

""" with Alt-Shift, substitute #, from "" to previous {string}
nnoremap <M-S-F4> :s#<C-r>"#~#<CR>
vnoremap <M-S-F4> <nop>
inoremap <M-S-F4> <C-o>:s#<C-r>"#~#<CR>

""" with Ctrl, confirm substitute /, waiting for {string}<CR>
nnoremap <C-F4> :s/<C-r>//~/<Left>
vnoremap <C-F4> <nop>
inoremap <C-F4> <C-o>:s/<C-r>//~/<Left>

""" with Ctrl-Shift, confirm substitute #, waiting for {string}<CR>
nnoremap <C-S-F4> :s#<C-r>/#~#<Left>
vnoremap <C-S-F4> <nop>
inoremap <C-S-F4> <C-o>:s#<C-r>/#~#<Left>

""" with Alt-Ctrl, confirm substitute /, from "", waiting for {string}<CR>
nnoremap <M-C-F4> :s/<C-r>"/~/<Left>
vnoremap <M-C-F4> <nop>
inoremap <M-C-F4> <C-o>:s/<C-r>"/~/<Left>

""" with Alt-Ctrl-Shift, confirm substitute #, from "", waiting for {string}<CR>
nnoremap <M-C-S-F4> :s#<C-r>"#~#<Left>
vnoremap <M-C-S-F4> <nop>
inoremap <M-C-S-F4> <C-o>:s#<C-r>"#~#<Left>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F5  yank
"     without Shift, yank word
"     with    Shift, yank WORD
"     without Ctrl,  yank inner
"     with    Ctrl,  yank around
"     without Alt,   yank into ""
"     with    Alt,   yank into "p

""" without modifier, yank internal word
nnoremap <F5>       yiw:echo 'yanked: ' . @"<CR>
vnoremap <F5>       <ESC>yiwgv
inoremap <F5>       <C-o>yiw

""" with Shift, yank internal WORD
nnoremap <S-F5>     yiW:echo 'yanked: ' . @"<CR>
vnoremap <S-F5>     <ESC>yiW
inoremap <S-F5>     <C-o>yiW

""" with Alt, yank internal word into "p
nnoremap <M-F5>     "pyiw:echo 'yanked [@p]: ' . @"<CR>
vnoremap <M-F5>     <ESC>"pyiwgv
inoremap <M-F5>     <C-o>"pyiw

""" with Alt-Shift, yank internal WORD into "p
nnoremap <M-S-F5>   "pyiW:echo 'yanked [@p]: ' . @"<CR>
vnoremap <M-S-F5>   <ESC>"pyiWgv
inoremap <M-S-F5>   <C-o>"pyiW

""" with Ctrl, yank around word
nnoremap <C-F5>     yaw:echo 'yanked: ' . @"<CR>
vnoremap <C-F5>     <ESC>yawgv
inoremap <C-F5>     <C-o>yaw

""" with Ctrl-Shift, yank around WORD
nnoremap <C-S-F5>   yaW:echo 'yanked: ' . @"<CR>
vnoremap <C-S-F5>   <ESC>yaWgv
inoremap <C-S-F5>   <C-o>yaW

""" with Alt-Ctrl, yank around word into "p
nnoremap <M-C-F5>   "pyaw:echo 'yanked [@p]: ' . @"<CR>
vnoremap <M-C-F5>   <ESC>"pyawgv
inoremap <M-C-F5>   <C-o>"pyiw

""" with Alt-Ctrl-Shift, yank around WORD into "p
nnoremap <M-C-S-F5> "pyaW:echo 'yanked [@p]: ' . @"<CR>
vnoremap <M-C-S-F5> <ESC>"pyaWgv
inoremap <M-C-S-F5> <C-o>"pyaW

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F6  select and put (replace)
"     without Shift, select word   and put
"     with    Shift, select WORD   and put
"     without Ctrl,  select inner  and put
"     with    Ctrl,  select around and put
"     without Alt,   select        and put ""
"     with    Alt,   select        and put "p

""" without modifier, select inner word and put ""
nnoremap <F6>       viwP:echo 'replaced: ' + @"<CR>
vnoremap <F6>       <ESC>viwPgv
inoremap <F6>       <C-o>viwP

""" with Shift, select inner WORD and put ""
nnoremap <S-F6>     viWP:echo 'replaced: ' + @"<CR>
vnoremap <S-F6>     <ESC>viWPgv
inoremap <S-F6>     <C-o>viWP

""" with Alt, select inner word and put "p
nnoremap <M-F6>     viw"pP:echo 'replaced: ' + @p<CR>
vnoremap <M-F6>     <ESC>viw"pPgv
inoremap <M-F6>     <C-o>viw"pP

""" with Alt-Shift, select inner WORD and put "p
nnoremap <M-S-F6>   viW"pP:echo 'replaced: ' + @p<CR>
vnoremap <M-S-F6>   <ESC>viW"pPgv
inoremap <M-S-F6>   <C-o>viW"pP

""" with Ctrl, select around word and put ""
nnoremap <C-F6>     vawP:echo 'replaced: ' + @"<CR>
vnoremap <C-F6>     <ESC>vawPgv
inoremap <C-F6>     <C-o>vawP

""" with Ctrl-Shift, select around WORD and put ""
nnoremap <C-S-F6>   vaWP:echo 'replaced: ' + @"<CR>
vnoremap <C-S-F6>   <ESC>vaWPgv
inoremap <C-S-F6>   <C-o>vaWP

""" with Alt-Ctrl, select around word and put "p
nnoremap <M-C-F6>   vaw"pP:echo 'replaced: ' + @p<CR>
vnoremap <M-C-F6>   <ESC>vaw"pPgv
inoremap <M-C-F6>   <C-o>vaw"pP

""" with Alt-Ctrl-Shift, select around WORD and put "p
nnoremap <M-C-S-F6> vaW"pP:echo 'replaced: ' + @p<CR>
vnoremap <M-C-S-F6> <ESC>vaW"pPgv
inoremap <M-C-S-F6> <C-o>vaW"pP

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F7  using digraph
"                     f<C-k>    cursor to Nth occurrence of {char} to the right
"               Shift F<C-k>    cursor to the Nth occurrence of {char} to the left
"          Ctrl       t<C-k>    cursor till before Nth occurrence of {char} right
"          Ctrl-Shift T<C-k>    cursor till after Nth occurrence of {char} to the left

""" without Alt, f/F/t/T digraph japanese shortcut
nnoremap <F7>               f<C-k>
inoremap <F7>               <C-o>f<C-k>
nnoremap <F7>a              f<C-k>ja
inoremap <F7>a              <C-o>f<C-k>ja
nnoremap <F7>i              f<C-k>ji
inoremap <F7>i              <C-o>f<C-k>ji
nnoremap <F7>u              f<C-k>ju
inoremap <F7>u              <C-o>f<C-k>ju
nnoremap <F7>e              f<C-k>je
inoremap <F7>e              <C-o>f<C-k>je
nnoremap <F7>o              f<C-k>jo
inoremap <F7>o              <C-o>f<C-k>jo
nnoremap <F7>nn             f<C-k>n5
inoremap <F7>nn             <C-o>f<C-k>n5
nnoremap <F7>,              f<C-k>j,
inoremap <F7>,              <C-o>f<C-k>j,
nnoremap <F7>.              f<C-k>j.
inoremap <F7>.              <C-o>f<C-k>j.
nnoremap <F7><Space>        f<C-k>IS
inoremap <F7><Space>        <C-o>f<C-k>IS
nnoremap <S-F7>             F<C-k>
inoremap <S-F7>             <C-o>F<C-k>
nnoremap <S-F7>a            F<C-k>ja
inoremap <S-F7>a            <C-o>F<C-k>ja
nnoremap <S-F7>i            F<C-k>ji
inoremap <S-F7>i            <C-o>F<C-k>ji
nnoremap <S-F7>u            F<C-k>ju
inoremap <S-F7>u            <C-o>F<C-k>ju
nnoremap <S-F7>e            F<C-k>je
inoremap <S-F7>e            <C-o>F<C-k>je
nnoremap <S-F7>o            F<C-k>jo
inoremap <S-F7>o            <C-o>F<C-k>jo
nnoremap <S-F7>nn           F<C-k>n5
inoremap <S-F7>nn           <C-o>F<C-k>n5
nnoremap <S-F7>,            F<C-k>j,
inoremap <S-F7>,            <C-o>F<C-k>j,
nnoremap <S-F7>.            F<C-k>j.
inoremap <S-F7>.            <C-o>F<C-k>j.
nnoremap <S-F7><Space>      F<C-k>IS
inoremap <S-F7><Space>      <C-o>F<C-k>IS
nnoremap <C-F7>             t<C-k>
inoremap <C-F7>             <C-o>t<C-k>
nnoremap <C-F7>a            t<C-k>ja
inoremap <C-F7>a            <C-o>t<C-k>ja
nnoremap <C-F7>i            t<C-k>ji
inoremap <C-F7>i            <C-o>t<C-k>ji
nnoremap <C-F7>u            t<C-k>ju
inoremap <C-F7>u            <C-o>t<C-k>ju
nnoremap <C-F7>e            t<C-k>je
inoremap <C-F7>e            <C-o>t<C-k>je
nnoremap <C-F7>o            t<C-k>jo
inoremap <C-F7>o            <C-o>t<C-k>jo
nnoremap <C-F7>nn           t<C-k>n5
inoremap <C-F7>nn           <C-o>t<C-k>n5
nnoremap <C-F7>,            t<C-k>j,
inoremap <C-F7>,            <C-o>t<C-k>j,
nnoremap <C-F7>.            t<C-k>j.
inoremap <C-F7>.            <C-o>t<C-k>j.
nnoremap <C-F7><Space>      t<C-k>IS
inoremap <C-F7><Space>      <C-o>t<C-k>IS
nnoremap <C-S-F7>           T<C-k>
inoremap <C-S-F7>           <C-o>T<C-k>
nnoremap <C-S-F7>a          T<C-k>ja
inoremap <C-S-F7>a          <C-o>T<C-k>ja
nnoremap <C-S-F7>i          T<C-k>ji
inoremap <C-S-F7>i          <C-o>T<C-k>ji
nnoremap <C-S-F7>u          T<C-k>ju
inoremap <C-S-F7>u          <C-o>T<C-k>ju
nnoremap <C-S-F7>e          T<C-k>je
inoremap <C-S-F7>e          <C-o>T<C-k>je
nnoremap <C-S-F7>o          T<C-k>jo
inoremap <C-S-F7>o          <C-o>T<C-k>jo
nnoremap <C-S-F7>nn         T<C-k>n5
inoremap <C-S-F7>nn         <C-o>T<C-k>n5
nnoremap <C-S-F7>,          T<C-k>j,
inoremap <C-S-F7>,          <C-o>T<C-k>j,
nnoremap <C-S-F7>.          T<C-k>j.
inoremap <C-S-F7>.          <C-o>T<C-k>j.
nnoremap <C-S-F7><Space>    T<C-k>IS
inoremap <C-S-F7><Space>    <C-o>T<C-k>IS

"     Meta            f<C-k>i   cursor to Nth occurrence of {char} to the right
"     Meta-     Shift F<C-k>i   cursor to the Nth occurrence of {char} to the left
"     Meta-Ctrl       t<C-k>i   cursor till before Nth occurrence of {char} right
"     Meta-Ctrl-Shift T<C-k>i   cursor till after Nth occurrence of {char} to the left

""" with Alt, f/F/t/T digraph japanese shortcut
nnoremap <M-F7>             f<C-k>j
inoremap <M-F7>             <C-o>f<C-k>j
nnoremap <M-F7>a            f<C-k>ja
inoremap <M-F7>a            <C-o>f<C-k>ja
nnoremap <M-F7>i            f<C-k>ji
inoremap <M-F7>i            <C-o>f<C-k>ji
nnoremap <M-F7>u            f<C-k>ju
inoremap <M-F7>u            <C-o>f<C-k>ju
nnoremap <M-F7>e            f<C-k>je
inoremap <M-F7>e            <C-o>f<C-k>je
nnoremap <M-F7>o            f<C-k>jo
inoremap <M-F7>o            <C-o>f<C-k>jo
nnoremap <M-F7>nn           f<C-k>n5
inoremap <M-F7>nn           <C-o>f<C-k>n5
nnoremap <M-F7>,            f<C-k>j,
inoremap <M-F7>,            <C-o>f<C-k>j,
nnoremap <M-F7>.            f<C-k>j.
inoremap <M-F7>.            <C-o>f<C-k>j.
nnoremap <M-F7><Space>      f<C-k>IS
inoremap <M-F7><Space>      <C-o>f<C-k>IS
nnoremap <M-S-F7>           F<C-k>j
inoremap <M-S-F7>           <C-o>F<C-k>j
nnoremap <M-S-F7>a          F<C-k>ja
inoremap <M-S-F7>a          <C-o>F<C-k>ja
nnoremap <M-S-F7>i          F<C-k>ji
inoremap <M-S-F7>i          <C-o>F<C-k>ji
nnoremap <M-S-F7>u          F<C-k>ju
inoremap <M-S-F7>u          <C-o>F<C-k>ju
nnoremap <M-S-F7>e          F<C-k>je
inoremap <M-S-F7>e          <C-o>F<C-k>je
nnoremap <M-S-F7>o          F<C-k>jo
inoremap <M-S-F7>o          <C-o>F<C-k>jo
nnoremap <M-S-F7>nn         F<C-k>n5
inoremap <M-S-F7>nn         <C-o>F<C-k>n5
nnoremap <M-S-F7>,          F<C-k>j,
inoremap <M-S-F7>,          <C-o>F<C-k>j,
nnoremap <M-S-F7>.          F<C-k>j.
inoremap <M-S-F7>.          <C-o>F<C-k>j.
nnoremap <M-S-F7><Space>    F<C-k>IS
inoremap <M-S-F7><Space>    <C-o>F<C-k>IS
nnoremap <M-C-F7>           t<C-k>j
inoremap <M-C-F7>           <C-o>t<C-k>j
nnoremap <M-C-F7>a          t<C-k>ja
inoremap <M-C-F7>a          <C-o>t<C-k>ja
nnoremap <M-C-F7>i          t<C-k>ji
inoremap <M-C-F7>i          <C-o>t<C-k>ji
nnoremap <M-C-F7>u          t<C-k>ju
inoremap <M-C-F7>u          <C-o>t<C-k>ju
nnoremap <M-C-F7>e          t<C-k>je
inoremap <M-C-F7>e          <C-o>t<C-k>je
nnoremap <M-C-F7>o          t<C-k>jo
inoremap <M-C-F7>o          <C-o>t<C-k>jo
nnoremap <M-C-F7>nn         t<C-k>n5
inoremap <M-C-F7>nn         <C-o>t<C-k>n5
nnoremap <M-C-F7>,          t<C-k>j,
inoremap <M-C-F7>,          <C-o>t<C-k>j,
nnoremap <M-C-F7>.          t<C-k>j.
inoremap <M-C-F7>.          <C-o>t<C-k>j.
nnoremap <M-C-F7><Space>    t<C-k>IS
inoremap <M-C-F7><Space>    <C-o>t<C-k>IS
nnoremap <M-C-S-F7>         T<C-k>j
inoremap <M-C-S-F7>         <C-o>T<C-k>j
nnoremap <M-C-S-F7>a        T<C-k>ja
inoremap <M-C-S-F7>a        <C-o>T<C-k>ja
nnoremap <M-C-S-F7>i        T<C-k>ji
inoremap <M-C-S-F7>i        <C-o>T<C-k>ji
nnoremap <M-C-S-F7>u        T<C-k>ju
inoremap <M-C-S-F7>u        <C-o>T<C-k>ju
nnoremap <M-C-S-F7>e        T<C-k>je
inoremap <M-C-S-F7>e        <C-o>T<C-k>je
nnoremap <M-C-S-F7>o        T<C-k>jo
inoremap <M-C-S-F7>o        <C-o>T<C-k>jo
nnoremap <M-C-S-F7>nn       t<C-k>n5
inoremap <M-C-S-F7>nn       <C-o>t<C-k>n5
nnoremap <M-C-S-F7>,        t<C-k>j,
inoremap <M-C-S-F7>,        <C-o>t<C-k>j,
nnoremap <M-C-S-F7>.        t<C-k>j.
inoremap <M-C-S-F7>.        <C-o>t<C-k>j.
nnoremap <M-C-S-F7><Space>  t<C-k>IS
inoremap <M-C-S-F7><Space>  <C-o>t<C-k>IS

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F8  <ESC>

" F8
nnoremap <F8>           <nop>
vnoremap <F8>           <nop>
inoremap <F8>           <nop>
onoremap <F8>           <nop>
nnoremap <S-F8>         <nop>
inoremap <S-F8>         <nop>
nnoremap <M-F8>         <nop>
inoremap <M-F8>         <nop>
nnoremap <M-S-F8>       <nop>
inoremap <M-S-F8>       <nop>
nnoremap <C-F8>         <nop>
inoremap <C-F8>         <nop>
nnoremap <C-S-F8>       <nop>
inoremap <C-S-F8>       <nop>
nnoremap <M-C-F8>       <nop>
inoremap <M-C-F8>       <nop>
nnoremap <M-C-S-F8>     <nop>
inoremap <M-C-S-F8>     <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F9  tab / (Alt) window
function! s:SearchJPLong(key, skey)
  let p ='\(^\S\\|^\s\+\zs\S\\|[。！？]\+\zs\\|$\)'
  call <SID>Search(a:key, a:skey, p)
endfunction

function! s:SearchJPMiddle(key, skey)
  let p ='\(^\S\\|\s\s\+\zs\S\\|[、。！？・（）「」『』【】]\+\zs\\|[\x01-\x7f]\zs[^\x01-\x7f]\@=\\|[^\x01-\x7f]\zs[\x01-\x7f]\@=\\|$\)'
  call <SID>Search(a:key, a:skey, p)
endfunction

function! s:SearchJPShort(key, skey)
  let p ='\(^\S\\|\s\+\zs\S\\|[、。！？・（）「」『』【】]\+\zs\\|[ぁ-ん]\+[、。！？（）「」『』【】]\+\zs\\|[ぁ-ん]\+\zs\\|[\x01-\x7f]\zs[^\x01-\x7f]\@=\\|[^\x01-\x7f]\zs[\x01-\x7f]\@=\\|$\)'
  call <SID>Search(a:key, a:skey, p)
endfunction

function! s:Search(key, skey, p)
  exec 'nnoremap ' . a:key  . '      /' . substitute(a:p, '/', '\\/', '') . '<CR>'
  exec 'vnoremap ' . a:key  . '      /' . substitute(a:p, '/', '\\/', '') . '<CR>'
  exec 'inoremap ' . a:key  . ' <C-o>/' . substitute(a:p, '/', '\\/', '') . '<CR>'
  exec 'nnoremap ' . a:skey . '      ?' . substitute(a:p, '?', '\\?', '') . '<CR>'
  exec 'vnoremap ' . a:skey . '      ?' . substitute(a:p, '?', '\\?', '') . '<CR>'
  exec 'inoremap ' . a:skey . ' <C-o>?' . substitute(a:p, '?', '\\?', '') . '<CR>'
endfunction

""" without Alt
call <SID>SearchJPShort('<F9>', '<S-F9>')
noremap <C-F9>         <nop>
noremap <C-S-F9>       <nop>
""" with Alt
noremap <M-F9>         <nop>
noremap <M-S-F9>       <nop>
noremap <M-C-F9>       <nop>
noremap <M-C-S-F9>     <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F10  nop

""" without Alt
call <SID>SearchJPMiddle('<F10>', '<S-F10>')
noremap <C-F10>         <nop>
noremap <C-S-F10>       <nop>
""" with Alt
noremap <M-F10>         <nop>
noremap <M-S-F10>       <nop>
noremap <M-C-F10>       <nop>
noremap <M-C-S-F10>     <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F11  nop

""" without Alt
call <SID>SearchJPLong('<F11>', '<S-F11>')
noremap <C-F11>         <nop>
noremap <C-S-F11>       <nop>
""" with Alt
noremap <M-F11>         <nop>
noremap <M-S-F11>       <nop>
noremap <M-C-F11>       <nop>
noremap <M-C-S-F11>     <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F12  toggle setting

""" without modifire, Toggle number, list, mouse to make it easy to copy/paste
" <F12>
nnoremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>:exec &laststatus == 2 ? "set laststatus=1" : "set laststatus=2"<CR>
inoremap <silent> <F12> <C-o>:set number!<CR><C-o>:set list!<CR><C-o>:exec &laststatus == 2 ? "set laststatus=1" : "set laststatus=2"<CR>

""" Toggle number, list, mouse to make it easy to copy/paste
" if has('mouse')
"   set mouse=a
"   noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>:exec &mouse != '' ? "set mouse=" : "set mouse=a"<CR>
" else
"   noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>
" endif

""" with Shift, Toggle scrolloff size (Shift = Scrolloff)
" <S-F12>
nnoremap <silent> <S-F12> <ESC>:<C-u>let &scrolloff=999-&scrolloff<CR>:echo "scrolloff = " . &scrolloff<CR>zt
inoremap <silent> <S-F12> <C-o>:let &scrolloff=999-&scrolloff<CR><C-o>:echo "scrolloff = " . &scrolloff<CR><C-o>zt

""" with Ctrl, Toggle cursorline, cursorcol (Ctrl = Cursorline, Cursorcol)
" <C-F12>
nnoremap <silent> <C-F12> <ESC>:set cursorline!<CR>:set cursorcolumn!<CR>
inoremap <silent> <C-F12> <C-o>:set cursorline!<CR><C-o>:set cursorcolumn!<CR>

""" with Ctrl+Shift, Toggle ignorecase (alternative search/replace condition)
" <C-S-F12>
nnoremap <silent> <C-S-F12> <ESC>:set ignorecase!<CR>:set ignorecase?<CR>
inoremap <silent> <C-S-F12> <C-o>:set ignorecase!<CR><C-o>:set ignorecase?<CR>

""" with Alt, Toggle Bash Keymap
" <M-F12>
nnoremap <silent> <M-F12> <ESC>:call <SID>ToggleBashKeymap()<CR>:echo exists("g:keymap_bash") ? "keymap_bash : on" : "keymap_bash : off"<CR>
inoremap <silent> <M-F12> <C-o>:call <SID>ToggleBashKeymap()<CR><C-o>:echo exists("g:keymap_bash") ? "keymap_bash : on" : "keymap_bash : off"<CR>

""" with Alt-Shift
" <M-S-F12>
noremap <M-S-F12>       <nop>

""" with Alt-Ctrl
" <M-C-F12>
noremap <M-C-F12>       <nop>

""" with Alt-Ctrl-Shift
" <M-C-S-F12>
noremap <M-C-S-F12>     <nop>

function! s:ToggleBashKeymap()
  if exists("g:keymap_bash")
    unlet g:keymap_bash
    nunmap <C-a>
    iunmap <C-a>
    nunmap <C-e>
    iunmap <C-e>
    nunmap <C-u>
    iunmap <C-u>
    nunmap <C-k>
    iunmap <C-k>
    nunmap <C-x>
    iunmap <C-x>
    nnoremap <C-k> <Up>
    inoremap <C-k> <Up>
  else
    let g:keymap_bash = 1
    nnoremap <C-a> 0
    inoremap <C-a> <C-o>0
    nnoremap <C-e> g_
    inoremap <C-e> <C-o>g_
    nnoremap <C-u> v0d
    inoremap <C-u> <C-o>v0d
    nnoremap <C-k> vg_d
    inoremap <C-k> <C-o>vg_d
    nnoremap <C-x> _x
    inoremap <C-x> <C-o>_x
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Insert> toggle insert/replace
"     Note: modifire is disabled in RLogin

""" with Shift, nop for RLogin PASTE
nnoremap <S-Insert> <nop>
vnoremap <S-Insert> <nop>
inoremap <S-Insert> <nop>

" nnoremap <M-Insert>     <nop> Not Available
" nnoremap <M-S-Insert>   <nop> Not Available
" nnoremap <C-Insert>     <nop> Not Available
" nnoremap <C-S-Insert>   <nop> Not Available
" nnoremap <M-C-Insert>   <nop> Not Available
" nnoremap <M-C-S-Insert> <nop> Not Available

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" <Del>
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

""" with Alt, erase {pattern} /
nnoremap <M-Del> :s/<C-r>///I<CR>
vnoremap <M-Del> "ry:s///I<CR>
inoremap <M-Del> <C-o>:s/<C-r>///I<CR>

""" with Alt-Shift, erase {pattern} #
nnoremap <M-S-Del> :s#<C-r>/##I<CR>
vnoremap <M-S-Del> "ry:s#<C-r>r##I<CR>
inoremap <M-S-Del> <C-o>:s#<C-r>/##I<CR>

""" with Ctrl, confirm erase {pattern} /
nnoremap <C-Del> :s/<C-r>///I<Left><Left><Left>
vnoremap <C-Del> "ry:s///I<Left><Left><Left>
inoremap <C-Del> <C-o>:s/<C-r>///I<Left><Left><Left>

""" with Ctrl-Shift, confirm erase {pattern} #
nnoremap <C-S-Del> :s#<C-r>/##I<Left><Left><Left>
vnoremap <C-S-Del> "ry:s#<C-r>r##I<Left><Left><Left>
inoremap <C-S-Del> <C-o>:s#<C-r>/##I<Left><Left><Left>

""" with Alt-Ctrl, <nop> for Windows Task Manager <Alt-Ctrl-Del>
nnoremap <M-C-Del> <nop>
vnoremap <M-C-Del> <nop>
inoremap <M-C-Del> <nop>

""" with Alt-Ctrl-Shift,
nnoremap <M-C-S-Del> <nop>
vnoremap <M-C-S-Del> <nop>
inoremap <M-C-S-Del> <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, cursor to start of line
" [default] nnoremap <Home>   0
" [default] vnoremap <Home>   0
" [default] inoremap <Home>   <C-o>0

""" with Shift, select to start of line
nnoremap <S-Home> v0
vnoremap <S-Home> 0
inoremap <S-Home> <C-o>v0

""" with Ctrl, cursor to first line
" [default] nnoremap <C-Home>    gg
" [default] vnoremap <C-Home>    gg
" [default] inoremap <C-Home>    <C-o>gg

""" with Ctrl-Shift, select to first line
nnoremap <C-S-Home> vgg
vnoremap <C-S-Home> gg
inoremap <C-S-Home> <C-o>vgg

""" with Alt, window up
nnoremap <M-Home> <C-w>W
vnoremap <M-Home> <C-w>W
inoremap <M-Home> <C-o><C-w>W

""" with Alt-Shift, window top
nnoremap <M-S-Home> <C-w>t
vnoremap <M-S-Home> <C-w>t
inoremap <M-S-Home> <C-o><C-w>t

""" with Alt-Ctrl, window rotate up
nnoremap <M-C-Home> <C-w>R
vnoremap <M-C-Home> <C-w>R
inoremap <M-C-Home> <C-o><C-w>R

""" with Alt-Ctrl-Shift, window to Tab
nnoremap <M-C-S-Home> <C-w>T
vnoremap <M-C-S-Home> <C-w>T
inoremap <M-C-S-Home> <C-o><C-w>T

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, cursor to end of line
" <End>
" [default] nnoremap <End> as is
" [default] vnoremap <End> as is
" [default] inoremap <End> as is

""" with Shift, select to end of line
nnoremap <S-End> v$
vnoremap <S-End> $
inoremap <S-End> <C-o>$

""" with Ctrl, cursor to last line
" [default] nnoremap <C-End> G
" [default] vnoremap <C-End> G
" [default] inoremap <C-End> <C-o>G

""" with Ctrl-Shift, select to last line
nnoremap <C-S-End> vG
vnoremap <C-S-End> G
inoremap <C-S-End> <C-o>vG

""" with Alt, window down
nnoremap <M-End> <C-w>w
vnoremap <M-End> <C-w>w
inoremap <M-End> <C-o><C-w>w

""" with Alt-Shift, window bottom
nnoremap <M-S-End> <C-w>b
vnoremap <M-S-End> <C-w>b
inoremap <M-S-End> <C-o><C-w>b

""" with Alt-Ctrl, window rotate down
nnoremap <M-C-End> <C-w>r
vnoremap <M-C-End> <C-w>r
inoremap <M-C-End> <C-o><C-w>r

""" with Alt-Ctrl-Shift, window to Tab
nnoremap <M-C-S-End> <C-w>T
vnoremap <M-C-S-End> <C-w>T
inoremap <M-C-S-End> <C-o><C-w>T

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, one screenful backward
" [default] nnoremap <PageUp> as is
" [default] vnoremap <PageUp> as is
" [default] inoremap <PageUp> as is

""" with Shift, select region
nnoremap <S-PageUp>   v<PageUp>
vnoremap <S-PageUp>   <PageUp>
inoremap <S-PageUp>   <C-o>v<PageUp>

""" with Ctrl, tab previous
" [default] nnoremap <S-PageUp>   gT
" [default] vnoremap <S-PageUp>   gT
" [default] inoremap <S-PageUp>   <C-o>gT

""" with Ctrl+Shift, go to first tab page
nnoremap <C-S-PageUp> :tabfirst<CR>
vnoremap <C-S-PageUp> <ESC>:tabfirst<CR>
inoremap <C-S-PageUp> <C-o>:tabfirst<CR>

""" with Alt, go window up
nnoremap <M-PageUp> <C-w>k
vnoremap <M-PageUp> <C-w>k
inoremap <M-PageUp> <C-o><C-w>k

""" with Alt-Shift, go window keft
nnoremap <M-S-PageUp> <C-w>h
vnoremap <M-S-PageUp> <C-w>h
inoremap <M-S-PageUp> <C-o><C-w>h

""" with Alt-Ctrl, window size highter
nnoremap <M-C-PageUp> <C-w>+
vnoremap <M-C-PageUp> <C-w>+
inoremap <M-C-PageUp> <C-o><C-w>+

""" with Alt-Ctrl-Shift, window size wider
nnoremap <M-C-S-PageUp> <C-w>>
vnoremap <M-C-S-PageUp> <C-w>>
inoremap <M-C-S-PageUp> <C-o><C-w>>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, one screenful forward
" [default] nnoremap <PageDown> as is
" [default] vnoremap <PageDown> as is
" [default] inoremap <PageDown> as is

""" with Shift, select region
nnoremap <S-PageDown> v<PageDown>
vnoremap <S-PageDown> <PageDown>
inoremap <S-PageDown> <C-o>v<PageDown>

""" with Ctrl, tab next
" [default] nnoremap <C-PageDown> gt
" [default] vnoremap <C-PageDown> <ESC>gt
" [default] inoremap <C-PageDown> <C-o>gt

""" with Ctrl-Shift, go to last tab page
nnoremap <C-S-PageDown> :tablast<CR>
vnoremap <C-S-PageDown> <ESC>:tablast<CR>
inoremap <C-S-PageDown> <C-o>:tablast<CR>

""" with Alt, go window down
nnoremap <M-PageDown> <C-w>j
vnoremap <M-PageDown> <C-w>j
inoremap <M-PageDown> <C-o><C-w>j

""" with Alt-Shift, go window right
nnoremap <M-S-PageDown> <C-w>l
vnoremap <M-S-PageDown> <C-w>l
inoremap <M-S-PageDown> <C-o><C-w>l

""" with Alt-Ctrl, window size shorter
nnoremap <M-C-PageDown> <C-w>-
vnoremap <M-C-PageDown> <C-w>-
inoremap <M-C-PageDown> <C-o><C-w>-

""" with Alt-Ctrl-Shift, window size nallower
nnoremap <M-C-S-PageDown> <C-w><
vnoremap <M-C-S-PageDown> <C-w><
inoremap <M-C-S-PageDown> <C-o><C-w><

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, Up
" [default] nnoremap <Up> as is
" [default] vnoremap <Up> as is
" [default] inoremap <Up> as is

""" with Shift, select region Up
" [default] nnoremap <S-Up>   <PageUp>
" [default] vnoremap <S-Up>   <PageUp>
" [default] inoremap <S-Up>   <C-o><PageUp>
nnoremap <S-Up> vk
vnoremap <S-Up> k
inoremap <S-Up> <C-o>vk

""" with Ctrl, 5 lines Up
" [default] nnoremap <C-Up> <PageUp>
" [default] vnoremap <C-Up> <ESC>gt
" [default] inoremap <C-Up> <C-o>gt
nnoremap <C-Up> 5k
vnoremap <C-Up> 5k
inoremap <C-Up> <C-o>5k

""" with Ctrl-Shift, select region 5 lines Up
nnoremap <C-S-Up>   v5k
vnoremap <C-S-Up>   5k
inoremap <C-S-Up>   <C-o>v5k

""" with Alt, window up
nnoremap <M-Up>   <C-w>k
vnoremap <M-Up>   <C-w>k
inoremap <M-Up>   <C-o><C-w>k

""" with Alt-Shift, window size taller
nnoremap <M-S-Up>   <C-w>+
vnoremap <M-S-Up>   <C-w>+
inoremap <M-S-Up>   <C-o><C-w>+

""" with Alt-Ctrl, nop
nnoremap <M-C-Up>   <nop>
vnoremap <M-C-Up>   <nop>
inoremap <M-C-Up>   <nop>

""" with Alt-Ctrl-Shift, nop
nnoremap <M-C-S-Up>   <nop>
vnoremap <M-C-S-Up>   <nop>
inoremap <M-C-S-Up>   <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, Down
" [default] nnoremap <Down> as is
" [default] vnoremap <Down> as is
" [default] inoremap <Down> as is

""" with Shift, Down
" [default] nnoremap <S-Down>   <PageDown>
" [default] vnoremap <S-Down>   <PageDown>
" [default] inoremap <S-Down>   <C-o><PageDown>
nnoremap <S-Down>   vj
vnoremap <S-Down>   j
inoremap <S-Down>   <C-o>vj

""" with Ctrl, 5 lines Down
nnoremap <C-Down> 5j
vnoremap <C-Down> 5j
inoremap <C-Down> <C-o>5j

""" with Ctrl-Shift, select 5 lines Down
nnoremap <C-S-Down> v5j
vnoremap <C-S-Down> 5j
inoremap <C-S-Down> <C-o>v5j

""" with Alt, window down
nnoremap <M-Down> <C-w>j
vnoremap <M-Down> <C-w>j
inoremap <M-Down> <C-o><C-w>j

""" with Alt-Shift, window size shorter
nnoremap <M-S-Down> <C-w>-
vnoremap <M-S-Down> <C-w>-
inoremap <M-S-Down> <C-o><C-w>-

""" with Alt-Ctrl, nop
nnoremap <M-C-Down> <nop>
vnoremap <M-C-Down> <nop>
inoremap <M-C-Down> <nop>

""" with Alt-Ctrl-Shift, nop
nnoremap <M-C-S-Down> <nop>
vnoremap <M-C-S-Down> <nop>
inoremap <M-C-S-Down> <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, Right
" [default] nnoremap <Right> as is
" [default] vnoremap <Right> as is
" [default] inoremap <Right> as is

""" with Shift, select region Right
" [default] nnoremap <S-Right> w
" [default] vnoremap <S-Right> w
" [default] inoremap <S-Right> <C-o>w
nnoremap <S-Right> v<Right>
vnoremap <S-Right> <Right>
inoremap <S-Right> <C-o>v<Right>

""" with Ctrl, 5 chars Right
" [default] nnoremap <C-Right> w
" [default] vnoremap <C-Right> w
" [default] inoremap <C-Right> <C-o>w
nnoremap <C-Right> 5<Right>
vnoremap <C-Right> 5<Right>
inoremap <C-Right> <C-o>v5<Right>

""" with Ctrl-Shift, select region 5 chars Right
nnoremap <C-S-Right> v5<Right>
vnoremap <C-S-Right> 5<Right>
inoremap <C-S-Right> <C-o>5<Right>

""" with Alt, window Right
nnoremap <M-Right> <C-w><Right>
vnoremap <M-Right> <C-w><Right>
inoremap <M-Right> <C-o><C-w><Right>

""" with Alt-Shift, window size wider
nnoremap <M-S-Right> <C-w>>
vnoremap <M-S-Right> <C-w>>
inoremap <M-S-Right> <C-o><C-w>>

""" with Alt-Ctrl, nop
nnoremap <M-C-Right> <nop>
vnoremap <M-C-Right> <nop>
inoremap <M-C-Right> <nop>

""" with Alt-Ctrl-Shift, nop
nnoremap <M-C-S-Right> <nop>
vnoremap <M-C-S-Right> <nop>
inoremap <M-C-S-Right> <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, Left
" [default] nnoremap <Left> as is
" [default] vnoremap <Left> as is
" [default] inoremap <Left> as is

""" with Shift, select region Left
" [default] nnoremap <S-Left>   b
" [default] vnoremap <S-Left>   b
" [default] inoremap <S-Left>   <C-o>b
nnoremap <S-Left>   v<Left>
vnoremap <S-Left>   <Left>
inoremap <S-Left>   <C-o>v<Left>

""" with Ctrl, 5 chars Left
" [default] nnoremap <C-Left>   b
" [default] vnoremap <C-Left>   b
" [default] inoremap <C-Left>   <C-o>b
nnoremap <C-Left>   5<Left>
vnoremap <C-Left>   5<Left>
inoremap <C-Left>   <C-o>v5<Left>

""" with Ctrl-Shift, select region 5 chars Left
nnoremap <C-S-Left>   v5<Left>
vnoremap <C-S-Left>   5<Left>
inoremap <C-S-Left>   <C-o>v5<Left>

""" with Alt, window Left
nnoremap <M-Left>   <C-w><Left>
vnoremap <M-Left>   <C-w><Left>
inoremap <M-Left>   <C-o><C-w><Left>

""" with Alt-Shift, window size narrower
nnoremap <M-S-Left>   <C-w><
vnoremap <M-S-Left>   <C-w><
inoremap <M-S-Left>   <C-o><C-w><

""" with Alt-Ctrl, nop
nnoremap <M-C-Left>   <nop>
vnoremap <M-C-Left>   <nop>
inoremap <M-C-Left>   <nop>

""" with Alt-Ctrl-Shift, nop
nnoremap <M-C-S-Left>   <nop>
vnoremap <M-C-S-Left>   <nop>
inoremap <M-C-S-Left>   <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" keys with Leader

let mapleader = "\<Space>"

" alternatives for Cursor Move key-mappings
" in Normal mode <C-l> redraw screen
nnoremap <Leader><C-l> <C-l> 

" toggle highlight search
nnoremap <silent> <Leader><Leader> :set hlsearch!<CR>
vnoremap <silent> <Leader><Leader> :<C-u>set hlsearch!<CR>gv

" execute selected command
" nnoremap <Leader><CR>     V:!/usr/bin/env bash
" vnoremap <Leader><CR>     :!/usr/bin/env bash

" reload .vimrc
nnoremap <silent> <Leader>rr :source ~/.vimrc<CR>:noh<CR>

" insert empty line
nnoremap <silent> <Leader>o o<ESC>
nnoremap <silent> <Leader>O O<ESC>
" insert empty line
nnoremap <silent> <Leader>oo :call append(line("."),   repeat([""], v:count1))<CR>
nnoremap <silent> <Leader>OO :call append(line(".")-1, repeat([""], v:count1))<CR>

" move cursor
" nnoremap <Leader><Left>   ^
" nnoremap <Leader><Right>  g_
" nnoremap <Leader><Up>     <C-u>
" nnoremap <Leader><Down>   <C-d>

" start selection
" nnoremap <Leader><S-Left>   v<Left>
" nnoremap <Leader><S-Right>  v<Right>
" nnoremap <Leader><S-Up>     v<Up>
" nnoremap <Leader><S-Down>   v<Down>


" Quickly move to the beginning of line
nnoremap <Leader><C-a> 0
" Move to the end of line
nnoremap <Leader><C-e> g_
" Delete all characters after the cursor (Kills forward)
nnoremap <Leader><C-k> dg_
" Delete all characters before the cursor (Kills backward)
nnoremap <Leader><C-u> d0
" Delete character under the cursor
nnoremap <Leader><C-x> "_x

" open window
nnoremap <Leader>ow :sp .
" open tab
nnoremap <Leader>ot :tabnew .

" insert line
" nnoremap <Leader>o o<Esc>
" nnoremap <Leader>O O<Esc>

" window open like tmux PREFIX " or PREFIX %
nnoremap <Leader>" :sp<CR>
nnoremap <Leader>% :vs<CR>
nnoremap <Leader><Left>   <C-w><Left>
nnoremap <Leader><Down>   <C-w><Down>
nnoremap <Leader><Up>     <C-w><Up>
nnoremap <Leader><Right>  <C-w><Right>
" tab open like tmux PREFIX c (create)
nnoremap <Leader>c :tabnew<CR>
nnoremap <Leader><C-n> gt
nnoremap <Leader><C-p> gT

" window open / window new
nnoremap <Leader>wo :sp .
nnoremap <Leader>wn :sp<CR>
" window rotate
nnoremap <Leader>wr <C-w>r
" window down
nnoremap <Leader>ww <C-w>w
" window left/down/up/right
nnoremap <Leader>wh        <C-w>h
nnoremap <Leader>wj        <C-w>j
nnoremap <Leader>wk        <C-w>k
nnoremap <Leader>wl        <C-w>l
nnoremap <Leader>w<Left>   <C-w><Left>
nnoremap <Leader>w<Down>   <C-w><Down>
nnoremap <Leader>w<Up>     <C-w><Up>
nnoremap <Leader>w<Right>  <C-w><Right>
" window size increase/decrease height
nnoremap <Leader>ws<Up>    <C-w>+
nnoremap <Leader>ws<Down>  <C-w>-
" window size increase/decrease width
nnoremap <Leader>ws<Right> <C-w>>
nnoremap <Leader>ws<Left>  <C-w><

" tab open / tab new
nnoremap <Leader>to :tabnew .
nnoremap <Leader>tn :tabnew<CR>
" table next/previous
nnoremap <Leader>tt gt
nnoremap <Leader>tT gT
" table rotate
nnoremap <Leader>tr :tabmove<CR>gt


" search forward using "/ (pattern)
nnoremap <Leader>/ /<C-r>/
vnoremap <Leader>/ y/<C-r>"

" search forward using "p (pattern)
nnoremap <Leader><C-f> /<C-r>p
vnoremap <Leader><C-f> "py/<C-r>p

" substitute from "" (unnamed) to "r (replace)
nnoremap <Leader><C-r>      :s/<C-r>"/<C-r>r/<Left>
vnoremap <Leader><C-r>   "ry:s/<C-r>"/<C-r>r/<Left>
nnoremap <Leader><C-S-r>    :s#<C-r>"#<C-r>r#<Left>
vnoremap <Leader><C-S-r> "ry:s#<C-r>"#<C-r>r#<Left>

" substitute from "p (pattern) to "r (replace)
nnoremap <Leader><C-r>      :s/<C-r>p/<C-r>r/<Left>
vnoremap <Leader><C-r>   "ry:s/<C-r>p/<C-r>r/<Left>
nnoremap <Leader><C-S-r>    :s#<C-r>p#<C-r>r#<Left>
vnoremap <Leader><C-S-r> "ry:s#<C-r>p#<C-r>r#<Left>

" yank "p (pattern)
nnoremap <Leader>py "py
vnoremap <Leader>py "py
" yank "r (replace)
nnoremap <Leader>ry "ry
vnoremap <Leader>ry "ry


" list registries/tabs/buffers
nnoremap <Leader>lr :reg<CR>
nnoremap <Leader>lt :tabs<CR>
nnoremap <Leader>lb :buffers<CR>
nnoremap <Leader>ls :ls<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Leader for digraph

""" use digraph {x}{x} (f: left index finger at home position)
nnoremap <Leader>f               f<C-k>
vnoremap <Leader>f               f<C-k>
nnoremap <Leader>fa              f<C-k>ja
vnoremap <Leader>fa              <C-o>f<C-k>ja
nnoremap <Leader>fi              f<C-k>ji
vnoremap <Leader>fi              <C-o>f<C-k>ji
nnoremap <Leader>fu              f<C-k>ju
vnoremap <Leader>fu              <C-o>f<C-k>ju
nnoremap <Leader>fe              f<C-k>je
vnoremap <Leader>fe              <C-o>f<C-k>je
nnoremap <Leader>fo              f<C-k>jo
vnoremap <Leader>fo              <C-o>f<C-k>jo
nnoremap <Leader>fnn             f<C-k>n5
vnoremap <Leader>fnn             <C-o>f<C-k>n5
nnoremap <Leader>f,              f<C-k>j,
vnoremap <Leader>f,              <C-o>f<C-k>j,
nnoremap <Leader>f.              f<C-k>j.
vnoremap <Leader>f.              <C-o>f<C-k>j.
nnoremap <Leader>f<Space>        f<C-k>IS
vnoremap <Leader>f<Space>        <C-o>f<C-k>IS

nnoremap <Leader>F               F<C-k>
vnoremap <Leader>F               F<C-k>
nnoremap <Leader>Fa              F<C-k>ja
vnoremap <Leader>Fa              <C-o>F<C-k>ja
nnoremap <Leader>Fi              F<C-k>ji
vnoremap <Leader>Fi              <C-o>F<C-k>ji
nnoremap <Leader>Fu              F<C-k>ju
vnoremap <Leader>Fu              <C-o>F<C-k>ju
nnoremap <Leader>Fe              F<C-k>je
vnoremap <Leader>Fe              <C-o>F<C-k>je
nnoremap <Leader>Fo              F<C-k>jo
vnoremap <Leader>Fo              <C-o>F<C-k>jo
nnoremap <Leader>Fnn             F<C-k>n5
vnoremap <Leader>Fnn             <C-o>F<C-k>n5
nnoremap <Leader>F,              F<C-k>j,
vnoremap <Leader>F,              <C-o>F<C-k>j,
nnoremap <Leader>F.              F<C-k>j.
vnoremap <Leader>F.              <C-o>F<C-k>j.
nnoremap <Leader>F<Space>        F<C-k>IS
vnoremap <Leader>F<Space>        <C-o>F<C-k>IS

nnoremap <Leader>t               t<C-k>
vnoremap <Leader>t               t<C-k>
nnoremap <Leader>ta              t<C-k>ja
vnoremap <Leader>ta              <C-o>t<C-k>ja
nnoremap <Leader>ti              t<C-k>ji
vnoremap <Leader>ti              <C-o>t<C-k>ji
nnoremap <Leader>tu              t<C-k>ju
vnoremap <Leader>tu              <C-o>t<C-k>ju
nnoremap <Leader>te              t<C-k>je
vnoremap <Leader>te              <C-o>t<C-k>je
nnoremap <Leader>to              t<C-k>jo
vnoremap <Leader>to              <C-o>t<C-k>jo
nnoremap <Leader>tnn             t<C-k>n5
vnoremap <Leader>tnn             <C-o>t<C-k>n5
nnoremap <Leader>t,              t<C-k>j,
vnoremap <Leader>t,              <C-o>t<C-k>j,
nnoremap <Leader>t.              t<C-k>j.
vnoremap <Leader>t.              <C-o>t<C-k>j.
nnoremap <Leader>t<Space>        t<C-k>IS
vnoremap <Leader>t<Space>        <C-o>t<C-k>IS

nnoremap <Leader>T               T<C-k>
vnoremap <Leader>T               T<C-k>
nnoremap <Leader>Ta              T<C-k>ja
vnoremap <Leader>Ta              <C-o>T<C-k>ja
nnoremap <Leader>Ti              T<C-k>ji
vnoremap <Leader>Ti              <C-o>T<C-k>ji
nnoremap <Leader>Tu              T<C-k>ju
vnoremap <Leader>Tu              <C-o>T<C-k>ju
nnoremap <Leader>Te              T<C-k>je
vnoremap <Leader>Te              <C-o>T<C-k>je
nnoremap <Leader>To              T<C-k>jo
vnoremap <Leader>To              <C-o>T<C-k>jo
nnoremap <Leader>Tnn             T<C-k>n5
vnoremap <Leader>Tnn             <C-o>T<C-k>n5
nnoremap <Leader>T,              T<C-k>j,
vnoremap <Leader>T,              <C-o>T<C-k>j,
nnoremap <Leader>T.              T<C-k>j.
vnoremap <Leader>T.              <C-o>T<C-k>j.
nnoremap <Leader>T<Space>        T<C-k>IS
vnoremap <Leader>T<Space>        <C-o>T<C-k>IS

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Function: SmartQ
"     Parameters:
"       reg
"         register name, e.g. 'a' means register @a
"       len
"         remove characters length.
"     Usage:
"         nnoremap q :<C-u>call <SID>SmartQ(2)<CR>
"         nnoremap Q q<CR>
" https://stackoverflow.com/questions/43654089/vim-mapping-q-only-when-not-recording
"
function! s:SmartQ(len)
  if exists("g:recording_macro")
    let r = g:recording_macro
    unlet g:recording_macro
    normal! q
    execute 'let @'.r.' = @'.r.'[:-'.a:len.']'
    echo 'recorded. Type @'.r.' to run the macro.'
  else
    echo '--recording : select register [0-9a-zA-Z] > '
    let c = nr2char(getchar())
    if c == ''
      let c = 'a'
    endif
    if c =~ '[0-9a-eA-Z"]'
      let g:recording_macro = c
      execute 'normal! q'.c
    else
      redraw
      echo 'aborted.'
    endif
  endif
endfunction
nnoremap Q q
nnoremap q :<C-u>call <SID>SmartQ(2)<CR>


""" Function: AltRecord
"     Parameters:
"       reg
"         register name, e.g. 'a' means register @a
"       len
"         remove characters length.
"     Usage:
"         nnoremap <S-F1> :<C-u>call <SID>AltRecord('a', 4)
"         nnoremap <S-F2> :<C-u>call <SID>AltRecord('b', 2)
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

""" yank text to clipboard by OSC52
" https://qiita.com/greymd/items/573e173d084470ee7b2d
function! s:OscyankPut(text)
  let encodedText=""
  if $TMUX != ""
    let encodedText=substitute(a:text, '\', '\\', "g")
  else
    let encodedText=substitute(a:text, '\', '\\\\', "g")
  endif
  let encodedText=substitute(encodedText, "\'", "'\\\\''", "g")
  let executeCmd="echo -n '".encodedText."' | base64 | tr -d '\\n'"
  let encodedText=system(executeCmd)
  if $TMUX != ""
    " tmux
    let executeCmd='echo -en "\033Ptmux;\033\033]52;;'.encodedText.'\033\033\\\\\033\\" > /dev/tty'
  elseif $TERM == "screen"
    " screen
    let executeCmd='echo -en "\033P\033]52;;'.encodedText.'\007\033\\" > /dev/tty'
  else
    let executeCmd='echo -en "\033]52;;'.encodedText.'\033\\" > /dev/tty'
  endif
  call system(executeCmd)
  redraw!
endfunction

if v:version < 800
  nnoremap yy yy:<C-u>call <SID>OscyankPut(getreg('"'))<CR>
  vnoremap y  y:<C-u>call <SID>OscyankPut(getreg('"'))<CR>
else
  augroup osc52
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call <SID>OscyankPut(getreg(v:event.regname)) | endif
  augroup END
endif

""" auto paste mode
" https://github.com/ConradIrwin/vim-bracketed-paste
if &term =~ "xterm" || &term =~ "screen" || &term =~ "tmux"
    let &t_ti .= "\e[?2004h"
    let &t_te = "\e[?2004l" . &t_te

    function! XTermPasteBegin(ret)
        set pastetoggle=<f29>
        set paste
        return a:ret
    endfunction

    execute "set <f28>=\<Esc>[200~"
    execute "set <f29>=\<Esc>[201~"
    map <expr> <f28> XTermPasteBegin("0i")
    imap <expr> <f28> XTermPasteBegin("")
    vmap <expr> <f28> XTermPasteBegin("c")
    cmap <f28> <nop>
    cmap <f29> <nop>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" digraph
" あ行
digraphs ja 12354  " あ
digraphs ji 12356  " い
digraphs ju 12358  " う
digraphs je 12360  " え
digraphs jo 12362  " お
digraphs nn 12435  " ん
digraphs jj 152    " j  for jj

" カッコ
digraphs j( 65288  " （
digraphs j) 65289  " ）
digraphs j[ 12300  " 「
digraphs j] 12301  " 」
digraphs j{ 12302  " 『
digraphs j} 12303  " 』
digraphs j< 12304  " 【
digraphs j> 12305  " 】

" 句読点
" digraphs j, 65292  " ，
" digraphs j. 65294  " ．
digraphs j, 12289  " 、
digraphs j. 12290  " 。
digraphs j! 65281  " ！
digraphs j? 65311  " ？
digraphs j: 65306  " ：

" 数字
digraphs j0 65296  " ０
digraphs j1 65297  " １
digraphs j2 65298  " ２
digraphs j3 65299  " ３
digraphs j4 65300  " ４
digraphs j5 65301  " ５
digraphs j6 65302  " ６
digraphs j7 65303  " ７
digraphs j8 65304  " ８
digraphs j9 65305  " ９

" その他の記号
digraphs j~ 12316  " ～ tilde
digraphs j/ 12539  " ・ slash
digraphs js 12288  " 　 space

" DON'T ERASE this!!
endif
" ======================================================================
""" usage """
" :e[dit] .        list files
" :%s/abc/xyz/gcI  global / confirm / case sensitive
" I xyz ESC .      repeat input commands 
" C-v ... xyz      BLOCK VISUAL selection input (multi cursor)
" C-p / C-n        auto complete
" viw              VISUAL internal word
" vi'              VISUAL internal ' and '
" vi(              VISUAL internal ( and )
" yiw              yank inner word
" diw              delete inner word
" daw              delete around word
" diW              delete inner WORD
" daW              delete around WORD
" dgn              delete next search
" dis              delete inner sentence
" das              delete around sentence
" dib              delete inner '(' ')' block
" dab              delete around '(' ')' block
" dip              delete inner paragraph
" dap              delete around paragraph
" diB              delete inner '{' '}' Block
" daB              delete around '{' '}' Block

""" (1) mode, save/quit
" i / a / o           enter INPUT mode. INPUT / APPEND / OPEN bottom
" I / A / O           enter INPUT mode at HEAD / END / OPEN upper
" v / S-v / C-v       enter VISUAL mode. VISUAL / LINE VISUAL / BLOCK VISUAL
" ESC                 back to NORMAL mode.
" u / C-r / .         Undo / Redo / repeat
" :w [filename]<CR>   write to file
" :q<CR>, :q!<CR>    quit (or close current tab/window) / quit force
" :wq<CR>, ZZ<CR>    write and quit (or close current tab/window)
" :e[dit] [filename] edit (open)

""" (2) cursor move
" h / j / k / l       left / down / up / right
" 0 / $               beginning / end of the line (HOME / END)
" ^                   move to fiest char of the line (hat character)
" w / e / b           next word / word end / word backword
" gg                  head of the file
" G                   bottom of the file
" {N}G                go to line N
" f.                  find next '.'
" F.                  find previous '.'

""" (3) edit text
" x                   delete char at the cursor
" yy                  yank line
" dd                  delete line (with yank)
" p                   paste
" v ... y             VISUAL selection yank (copy)
" v ... x             VISUAL selection delete
" v ... d             VISUAL selection delete (with yank)
" 3x                  delete 3 chars
" d2w                 delete 2 words

""" (4) find / replace
" /xyz<CR>              find 'xyz'
" ?xyz<CR>              find 'xyz' backword
" :%s/xyz/XYZ/gcI<CR>   all lines(%) substitute 'xyz' to 'XYZ' global(g), confirm(c), case sensitive(I)
" /xyz\c<CR>            find 'xyz' case insensitive
" /xyz\C<CR>            find 'xyz' case sensitive
" :s/xyz/XYZ/<CR>       current line substitute 'xyz' to 'XYZ' (first found only)
" :s/xyz/XYZ/gc<CR>     current line substitute 'xyz' to 'XYZ' global(g), confirm(c)
" :%s/xyz\c/XYZ/gc<CR>  all lines(%) substitute 'xyz' to 'XYZ' case insensitive(\c), global(g), confirm(c)
" :%s/xyz\C/XYZ/gc<CR>  all lines(%) substitute 'xyz' to 'XYZ' case sensitive(\C), global(g), confirm(c)

""" (5) window
" C-w s, :sp<CR>   split window horizontal
" C-w +, C-W -     change window height (+ for heigher, - for shorter)
" C-w v, :vs<CR>   split window horizontal
" C-w >, C-W <     change window width (> for wider, < for narrower)
" C-w q, :q<CR>    close current window
" C-w o            only current window (close other windows)
" C-w w, C-w C-w   next window
" C-w W            previous window
" C-w h/j/k/l      move left/down/up/right window
" C-w r, C-w C-r   rotate window

""" (6) tabpage
" :tabnew [filename]     tab new
" :tabe[dit] [filename]  tab edit
" :tabc[lose]<CR>        tab close
" :tabo[nly]<CR>         tab only current tab (close other tabs)
" :tabn[ext]<CR>, gt, C-PageDown     tab next
" :tabN[ext]<CR>, gT, C-PageUp       tab previous
" :tabf[irst]<CR>        tab first
" :tabl[ast]<CR>         tab last
" :tabs<CR>              show list of tabs
" :tabm[ove] +{N}<CR>    tab move right N times
" :tabm[ove] -{N}<CR>    tab move left N times

""" (7) folding
" {N}zf / zf{N}      fold N+1 lines
" zo / zO            open one / open recursive
" za / zA            open all / fold all
" zi                 inverse open,fold

""" (8) recording
" qa                recording start into register "a if not recording
" q                 recording end if recording in NORMAL mode
" C-o q             recording end if recording in INSERT mode
" @a                execute command in register "a

""" (9) register
" :reg         show register list
" "ayy         yank current line into register a
" "ap          paste register a
" C-v ... "ay  yank selected region into register a
" 
" |register| description                                         |
" |:-------|:----------------------------------------------------|
" | ""     | unnamed register, used when yank(y), delete(d) etc. |
" | "0     | numbered register (yanked text)                     |
" | "1-    | numbered register (deleted line text)               |
" | "2-"9  | numbered register (previous register content)       |
" | "a-"z  | named register (overwrite)                          |
" | "A-"Z  | named register (append to register a-z)             |
" | "%     | read only register (current filename)               |
" | "#     | read only register (alternate filename)             |
" | "*     | the clipboard contents                              |
" | "+     | the clipboard contents                              |
" | "/     | the last search pattern                             |
" | ":     | the last command-line                               |
" | ".     | read only register (last inserted text)             |
" | "-     | register for small delete                           |
" | "=     | the expression register e                           |

""" (10) buffer
" :ls, :buffers, :files  show buffer list
" :e[dit] FILENAME       open file (create buffer)
" :bd[elete] 3           delete buffer 3
" :b 3                   show buffer 3
" :bprev[ous]            buffer previous
" :bnext                 buffer next
" :bfirst                buffer first
" :blast                 buffer last

""" (11) mark
" :marks                
" ma           set mark a {A-Za-z} at cursor position
" delma        delete mark a {A-Za-z}
" delmarsk!    delete all marks
" `a           cursor to the mark a {A-Za-z0-9}
" 'a           cursor to the first CHAR on the line with mark a {A-Za-z09}
" [`           cursor to previous lowercase mark
" ]`           cursor to next lowercase mark
" ['           cursor to previous lowercase mark, on first non-blank
" ]'           cursor to next lowercase mark, on first non-blank
" c`a          change from current cursor position to position mark a
" d`a          delete from current cursor position to position mark a
" y`a          yank from current cursor position to position mark a

""" (12) jump list
" :ju[mps]    print the jump list
" <C-o>       go to N older entry in jump list
" <C-i>       go to N newer entry in jump list

""" check key code
" $ sed -n l
" exit with Ctrl-D or Ctrl-C
