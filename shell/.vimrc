" $ curl https://raw.githubusercontent.com/thino-rma/PlayGround/master/shell/.vimrc -o ~/.vimrc
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
set list           " show unvisible character

""" list characters
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

""" number format : this affects C-a (increment), C-x (decrement)
set nrformats-=octal,hex

set number         " Show line number

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

"=== for vim ===========================================================

set clipboard=unnamedplus
" set cursorline
" set cursorcolumn
set history=50
set hlsearch
set scrolloff=5
set showcmd
" set smartindent
set textwidth=0
set title
set virtualedit=block
set whichwrap=b,s,[,],<,>
set wildmenu
set wildmode=list:longest

filetype plugin indent on
syntax on

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
" you may have to set keycode for Shift-F1: type i (insert mode), type C-v, type Shift-F1.
execute "set <S-F1>=\<Esc>[11;2~"
execute "set <S-F2>=\<Esc>[12;2~"
execute "set <S-F3>=\<Esc>[13;2~"
execute "set <S-F4>=\<Esc>[14;2~"

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
" <S-F1>
nnoremap <S-F1>      :<C-u>call <SID>AltRecord('a', 4)<CR>
" <M-F1>
nnoremap <ESC>[11;3~ :<C-u>call <SID>AltRecord('b', 8)<CR>
" <M-S-F1>
nnoremap <ESC>[11;4~ :<C-u>call <SID>AltRecord('c', 8)<CR>
" <C-F1>
nnoremap <ESC>[11;5~ :<C-u>call <SID>AltRecord('d', 8)<CR>
" <C-S-F1>
nnoremap <ESC>[11;6~ :<C-u>call <SID>AltRecord('e', 8)<CR>
" <M-C-F1>
nnoremap <ESC>[11;7~ :<C-u>call <SID>AltRecord('f', 8)<CR>
" <M-C-S-F1>
nnoremap <ESC>[11;8~ :<C-u>call <SID>AltRecord('g', 8)<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F2  execute register
"     Hint: :reg shows register list, (use F2)

""" show register
nnoremap <F2>        :<C-u>reg<CR>
inoremap <F2>        <nop>
""" execute macro in register
" <S-F2>
nnoremap <S-F2>      @a
" <M-F2>
nnoremap <ESC>[12;3~ @b
" <M-S-F2>
nnoremap <ESC>[12;4~ @c
" <C-F2>
nnoremap <ESC>[12;5~ @d
" <C-S-F2>
nnoremap <ESC>[12;6~ @e
" <M-C-F2>
nnoremap <ESC>[12;7~ @f
" <M-C-S-F2>
nnoremap <ESC>[12;8~ @g

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
" <F3>
nnoremap <F3>   n
vnoremap <F3>   n
inoremap <F3>   <C-o>n

""" with Shift, search previous
" <S-F3>
nnoremap <S-F3> N
vnoremap <S-F3> N
inoremap <S-F3> <C-o>N

""" with Alt, search forward, using "" (unnamed)
" <M-F3>
nnoremap <ESC>[13;3~ /<C-r>"<CR>
vnoremap <ESC>[13;3~ y/<C-r>"<CR>
inoremap <ESC>[13;3~ <C-o>/<C-r>"<CR>

""" with Alt-Shift, search backword, using "" (unnamed)
" <M-S-F3>
nnoremap <ESC>[13;4~ ?<C-r>"<CR>
vnoremap <ESC>[13;4~ y?<C-r>"<CR>
inoremap <ESC>[13;4~ <C-o>?<C-r>"<CR>

""" with Ctrl, confirm search forward, waiting for <CR>
"   if IME ON, use just /.
" <C-F3>
nnoremap <ESC>[13;5~ /<C-r>/
vnoremap <ESC>[13;5~ /<C-r>/
inoremap <ESC>[13;5~ <C-o>/<C-r>/

""" with Ctrl-Shift, confirm search backward, waiting for <CR>
"   if IME ON, use just ?.
" <C-S-F3>
nnoremap <ESC>[13;6~ ?<C-r>/
vnoremap <ESC>[13;6~ ?<C-r>/
inoremap <ESC>[13;6~ <C-o>?<C-r>/

""" with Alt-Ctrl, confirm search forward, using "" (unnamed), waiting for <CR>
" <M-C-F3>
nnoremap <ESC>[13;7~ /<C-r>"
vnoremap <ESC>[13;7~ /<C-r>"
inoremap <ESC>[13;7~ <C-o>/<C-r>"

""" with Alt-Ctrl-Shift, confirm search backword, using "" (unnamed), waiting for <CR>
" <M-C-S-F3> substitute
nnoremap <ESC>[13;8~ ?<C-r>"
vnoremap <ESC>[13;8~ ?<C-r>"
inoremap <ESC>[13;8~ <C-o>?<C-r>"

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
" F4
nnoremap <F4>        &
vnoremap <F4>        <nop>
inoremap <F4>        <C-o>&

""" with Shift, repeat last substitute
"   so that you can use F3 and F4 repeatedly.
" <S-F4>
nnoremap <S-F4>      &
vnoremap <S-F4>      <nop>
inoremap <S-F4>      <C-o>&

""" with Alt, substitute /, using from  "" to previous {string}
" <M-F4>
nnoremap <ESC>[14;3~      :s/<C-r>"/~/<CR>
vnoremap <ESC>[14;3~ <nop>
inoremap <ESC>[14;3~ <C-o>:s/<C-r>"/~/<CR>

""" with Alt-Shift, substitute #, from "" to previous {string}
" <M-S-F4>
nnoremap <ESC>[14;4~      :s#<C-r>"#~#<CR>
vnoremap <ESC>[14;4~ <nop>
inoremap <ESC>[14;4~ <C-o>:s#<C-r>"#~#<CR>

""" with Ctrl, confirm substitute /, waiting for {string}<CR>
" <C-F4>
nnoremap <ESC>[14;5~      :s/<C-r>//~/<Left>
vnoremap <ESC>[14;5~ <nop>
inoremap <ESC>[14;5~ <C-o>:s/<C-r>//~/<Left>

""" with Ctrl-Shift, confirm substitute #, waiting for {string}<CR>
" <C-S-F4>
nnoremap <ESC>[14;6~      :s#<C-r>/#~#<Left>
vnoremap <ESC>[14;6~ <nop>
inoremap <ESC>[14;6~ <C-o>:s#<C-r>/#~#<Left>

""" with Alt-Ctrl, confirm substitute /, from "", waiting for {string}<CR>
" <M-C-F4>
nnoremap <ESC>[14;7~      :s/<C-r>"/~/<Left>
vnoremap <ESC>[14;7~ <nop>
inoremap <ESC>[14;7~ <C-o>:s/<C-r>"/~/<Left>

""" with Alt-Ctrl-Shift, confirm substitute #, from "", waiting for {string}<CR>
" <M-C-S-F4>
nnoremap <ESC>[14;8~      :s#<C-r>"#~#<Left>
vnoremap <ESC>[14;8~ <nop>
inoremap <ESC>[14;8~ <C-o>:s#<C-r>"#~#<Left>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F5  yank
"     Hint: yank or select word/WORD

""" without modifier, yank internal word
" <F5>
nnoremap <F5>       yiw:echo 'yanked: ' . @"<CR>
vnoremap <F5>       <ESC>yiwgv
inoremap <F5>       <C-o>yiw

""" with Shift, yank internal WORD
" <S-F5>
nnoremap <S-F5>     yiW:echo 'yanked: ' . @"<CR>
vnoremap <S-F5>     <ESC>yiWgv
inoremap <S-F5>     <C-o>yiW

""" with Alt, yank to end of the line (printable)
" <M-F5>
nnoremap <M-F5>     "pyiw:echo 'yanked: ' . @"<CR>
vnoremap <M-F5>     <ESC>"pyiwgv
inoremap <M-F5>     <C-o>"pyiw

""" with Alt-Shift, yank to end of the line
" <M-S-F5>
nnoremap <M-S-F5>   "pyiW:echo 'yanked: ' . @"<CR>
vnoremap <M-S-F5>   <ESC>"pyiWgv
inoremap <M-S-F5>   <C-o>"pyiW

""" with Ctrl, yank to the begin of line
" <C-F5>
nnoremap <C-F5>     viw
vnoremap <C-F5>     <ESC>viw
inoremap <C-F5>     <C-o>viw

""" with Ctrl-Shift, same as with Ctrl
" <C-S-F5>
nnoremap <C-S-F5>   viW
vnoremap <C-S-F5>   <ESC>viW
inoremap <C-S-F5>   <C-o>viW

""" with Alt-Ctrl, yank to end of the line (printable)
" <M-C-F5>
nnoremap <M-C-F5>   viw"p:s/<C-r>p//<Left>
vnoremap <M-C-F5>   <ESC>viw"p:s/<C-r>p//<Left>
inoremap <M-C-F5>   <C-o>viw"p<C-o>:s/<C-r>p//<Left>

""" with Alt-Ctrl-Shift, nop
" <M-C-S-F5>
nnoremap <M-C-S-F5> viW"p:s/<C-r>p//<Left>
vnoremap <M-C-S-F5> <ESC>viW"p:s/<C-r>p//<Left>
inoremap <M-C-S-F5> <C-o>viW"p<C-o>:s/<C-r>p//<Left>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F6  select and put (replace)
"     Hint: replace with unnamed register ("")

""" without modifier, elect word and put ""
" F6
nnoremap <F6>       viwP
vnoremap <F6>       <ESC>viwPgv
inoremap <F6>       <C-o>viwP

""" with Shift, select WORD and put ""
" <S-F6>
nnoremap <S-F6>     viWP
vnoremap <S-F6>     <ESC>viWPgv
inoremap <S-F6>     <C-o>viWP

""" with Alt, select word and put "p
" <M-F6>
nnoremap <M-F6>     viw"pP
vnoremap <M-F6>     <ESC>viw"pPgv
inoremap <M-F6>     <C-o>viw"pP

""" with Alt-Shift, select WORD and put "p
" <M-S-F6>
nnoremap <M-S-F6>   viW"pP
vnoremap <M-S-F6>   <ESC>viW"pPgv
inoremap <M-S-F6>   <C-o>viW"pP

""" with Ctrl, nop
" <C-F6>
nnoremap <C-F6>     <nop>
vnoremap <C-F6>     <nop>
inoremap <C-F6>     <nop>

""" with Ctrl-Shift, nop
" <C-S-F6>
nnoremap <C-S-F6>   <nop>
vnoremap <C-S-F6>   <nop>
inoremap <C-S-F6>   <nop>

""" with Ctrl-Shift, nop
" <M-C-F6>
nnoremap <M-C-F6>   <nop>
vnoremap <M-C-F6>   <nop>
inoremap <M-C-F6>   <nop>

""" with Alt-Ctrl-Shift, nop
" <M-C-S-F6>
nnoremap <M-C-S-F6> <nop>
vnoremap <M-C-S-F6> <nop>
inoremap <M-C-S-F6> <nop>
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
" F8  <nop>

" F8
nnoremap <F8>           <nop>
nnoremap <S-F8>         <nop>
nnoremap <M-F8>         <nop>
nnoremap <M-S-F8>       <nop>
nnoremap <C-F8>         <nop>
nnoremap <C-S-F8>       <nop>
nnoremap <M-C-F8>       <nop>
nnoremap <M-C-S-F8>     <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F9  tab / (Alt) window

function! s:SearchEN(key, skey)
  let p = '\(^\\|\s\+\zs\\|,\\|\.\\|!\\|?\\|"\\|' . "'" . '\\|(\\|)\\|$\)'
  call <SID>Search(a:key, a:skey, p)
endfunction

function! s:SearchJP(key, skey)
  let p = '\(^\\|\s\+\zs\\|　\+\zs\\|、\\|。\\|！\\|？\\|「\\|」\\|（\\|）\\|$\)'
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
call <SID>SearchEN('<F9>', '<S-F9>')
noremap <C-F9>         <nop>
noremap <C-S-F9>       <nop>
""" with Alt
noremap <M-F9>         <nop>
noremap <M-S-F9>       <nop>
noremap <M-C-F9>       <nop>
noremap <M-C-S-F9>     <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F10  nop

" F10
call <SID>SearchJP('<F10>', '<S-F10>')
noremap <A-F10>         <nop>
noremap <S-A-F10>       <nop>
noremap <C-F10>         <nop>
noremap <C-S-F10>       <nop>
noremap <C-A-F10>       <nop>
noremap <C-S-A-F10>     <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F11  nop

" F11
noremap <F11>           <nop>
noremap <S-F11>         <nop>
noremap <A-F11>         <nop>
noremap <S-A-F11>       <nop>
noremap <C-F11>         <nop>
noremap <C-S-F11>       <nop>
noremap <C-A-F11>       <nop>
noremap <C-S-A-F11>     <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F12  toggle setting

""" without modifire, Toggle number, list, mouse to make it easy to copy/paste
" <F12>
nnoremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>
inoremap <silent> <F12> <C-o>:set number!<CR><C-o>:set list!<CR>

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
" <Insert>
" nnoremap <Insert>
""" with Shift, RLogin PASTE
" <S-Insert>
" nnoremap <ESC>[2;2    <nop> NOT AVAILABLE
" <M-Insert>
" nnoremap <ESC>[2;3    <nop>
" <M-S-Insert>
" nnoremap <ESC>[2;4    <nop>
" <C-Insert>
" nnoremap <ESC>[2;5    <nop>
" <C-S-Insert>
" nnoremap <ESC>[2;6    <nop>
" <M-C-Insert>
" nnoremap <ESC>[2;7    <nop>
" <M-C-S-Insert>
" nnoremap <ESC>[2;8    <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, delete character under the cursor
" <Del>
" Note: use "d"(delete) and "p"(put) for "cut  and paste"
" Note: use "y"(yank)   and "p"(put) for "copy and paste"
" using blackhole register
nnoremap <Del> "_x
vnoremap <Del> "_x
inoremap <Del> <C-o>"_x

""" with Shift, delete character under the cursor
" <S-Del>
" using unnameed register
nnoremap <ESC>[3;2~   x
vnoremap <ESC>[3;2~   x
inoremap <ESC>[3;2~   <C-o>x

""" with Alt, erase {pattern} /
" <M-Del>
nnoremap <ESC>[3;3~   :s/<C-r>///I<CR>
vnoremap <ESC>[3;3~   "ry:s///I<CR>
inoremap <ESC>[3;3~   <C-o>:s/<C-r>///I<CR>

""" with Alt-Shift, erase {pattern} #
" <M-S-Del>
nnoremap <ESC>[3;4~   :s#<C-r>/##I<CR>
vnoremap <ESC>[3;4~   "ry:s#<C-r>r##I<CR>
inoremap <ESC>[3;4~   <C-o>:s#<C-r>/##I<CR>

""" with Ctrl, confirm erase {pattern} /
" <C-Del>
nnoremap <ESC>[3;5~   :s/<C-r>///I<Left><Left><Left>
vnoremap <ESC>[3;5~   "ry:s///I<Left><Left><Left>
inoremap <ESC>[3;5~   <C-o>:s/<C-r>///I<Left><Left><Left>

""" with Ctrl-Shift, confirm erase {pattern} #
" <C-S-Del>
nnoremap <ESC>[3;6~   :s#<C-r>/##I<Left><Left><Left>
vnoremap <ESC>[3;6~   "ry:s#<C-r>r##I<Left><Left><Left>
inoremap <ESC>[3;6~   <C-o>:s#<C-r>/##I<Left><Left><Left>

" <M-C-Del>
" nnoremap <ESC>[3;7~   <nop>
" <M-C-S-Del>
" nnoremap <ESC>[3;8~   <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, cursor to start of line
" <Home>
" [default] nnoremap <Home>   0
" [default] vnoremap <Home>   0
" [default] inoremap <Home>   <C-o>0

""" with Shift, select to start of line
" <S-Home>
nnoremap <ESC>O2H    v0
vnoremap <ESC>O2H    0
inoremap <ESC>O2H    <C-o>v0

""" with Ctrl, cursor to first line
" <C-Home>
" [default] nnoremap <ESC>O5H    gg
" [default] vnoremap <ESC>O5H    gg
" [default] inoremap <ESC>O5H    <C-o>gg

""" with Ctrl-Shift, select to first line
" <C-S-Home>
nnoremap <ESC>O6H    vgg
vnoremap <ESC>O6H    gg
inoremap <ESC>O6H    <C-o>vgg

""" with Alt, window up
" <M-Home>
nnoremap <ESC>O3H    <C-w>W
vnoremap <ESC>O3H    <C-w>W
inoremap <ESC>O3H    <C-o><C-w>W

""" with Alt-Shift, window top
" <M-S-Home>
nnoremap <ESC>O4H    <C-w>t
vnoremap <ESC>O4H    <C-w>t
inoremap <ESC>O4H    <C-o><C-w>t

""" with Alt-Ctrl, window rotate up
" <M-C-Home>
nnoremap <ESC>O7H    <C-w>R
vnoremap <ESC>O7H    <C-w>R
inoremap <ESC>O7H    <C-o><C-w>R

""" with Alt-Ctrl-Shift, window to Tab
" <M-C-S-Home>
nnoremap <ESC>O8H    <C-w>T
vnoremap <ESC>O8H    <C-w>T
inoremap <ESC>O8H    <C-o><C-w>T

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, cursor to end of line
" <End>
nnoremap <End>   g_
vnoremap <End>   g_
inoremap <End>   <C-o>g_

""" with Shift, select to end of line(printable)
" <S-End>
nnoremap <ESC>O2F    vg_
vnoremap <ESC>O2F    g_
inoremap <ESC>O2F    <C-o>vg_

""" with Ctrl, cursor to last line
" <C-End>
" [default] nnoremap <ESC>O5F   G
" [default] vnoremap <ESC>O5F   G
" [default] inoremap <ESC>O5F   <C-o>G

""" with Ctrl-Shift, select to last line
" <C-S-End>
nnoremap <ESC>O6F    vG
vnoremap <ESC>O6F    G
inoremap <ESC>O6F    <C-o>vG

""" with Alt, window down
" <M-End>
nnoremap <ESC>03F   <C-w>w
vnoremap <ESC>03F   <C-w>w
inoremap <ESC>03F   <C-o><C-w>w
""" with Alt-Shift, window bottom
" <M-S-End>
nnoremap <ESC>O4F    <C-w>b
vnoremap <ESC>O4F    <C-w>b
inoremap <ESC>O4F    <C-o><C-w>b

""" with Alt-Ctrl, window rotate down
" <M-C-End>
nnoremap <ESC>O7F   <C-w>r
vnoremap <ESC>O7F   <C-w>r
inoremap <ESC>O7F   <C-o><C-w>r

""" with Alt-Ctrl-Shift, window to Tab
" <M-C-S-End>
nnoremap <ESC>O8F   <C-w>T
vnoremap <ESC>O8F   <C-w>T
inoremap <ESC>O8F   <C-o><C-w>T

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, one screenful backward
" <PageUp>
" [default] nnoremap <ESC>[5~ as is
" [default] vnoremap <ESC>[5~ as is
" [default] inoremap <ESC>[5~ as is

""" with Shift, select region
" <S-PageUp>
nnoremap <ESC>[5;2~   v<PageUp>
vnoremap <ESC>[5;2~   <PageUp>
inoremap <ESC>[5;2~   <C-o>v<PageUp>

""" with Ctrl, tab previous
" <C-PageUp>
" [default] nnoremap <ESC>[5;5~   gT
" [default] vnoremap <ESC>[5;5~   gT
" [default] inoremap <ESC>[5;5~   <C-o>gT

""" with Ctrl+Shift, go to first tab page
" <C-S-PageUp>
nnoremap <ESC>[5;6~   :tabfirst<CR>
vnoremap <ESC>[5;6~   <ESC>:tabfirst<CR>
inoremap <ESC>[5;6~   <C-o>:tabfirst<CR>

""" with Alt, go window up
" <M-PageUp>
nnoremap <ESC>[5;3~   <C-w>k
vnoremap <ESC>[5;3~   <C-w>k
inoremap <ESC>[5;3~   <C-o><C-w>k

""" with Alt-Shift, go window keft
" <M-S-PageUp>
nnoremap <ESC>[5;4~   <C-w>h
vnoremap <ESC>[5;4~   <C-w>h
inoremap <ESC>[5;4~   <C-o><C-w>h

""" with Alt-Ctrl, window size highter
" <M-C-PageUp>
nnoremap <ESC>[5;7~   <C-w>+
vnoremap <ESC>[5;7~   <C-w>+
inoremap <ESC>[5;7~   <C-o><C-w>+

""" with Alt-Ctrl-Shift, window size wider
" <M-C-S-PageUp>
nnoremap <ESC>[5;8~   <C-w>>
vnoremap <ESC>[5;8~   <C-w>>
inoremap <ESC>[5;8~   <C-o><C-w>>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, one screenful forward
" <PageDown>
" [default] nnoremap <ESC>[6~ as is
" [default] vnoremap <ESC>[6~ as is
" [default] inoremap <ESC>[6~ as is

""" with Shift, select region
" <S-PageDown>
nnoremap <ESC>[6;2~   v<PageDown>
vnoremap <ESC>[6;2~   <PageDown>
inoremap <ESC>[6;2~   <C-o>v<PageDown>

""" with Ctrl, tab next
" <C-PageDown>
" [default] nnoremap <ESC>[6;5~   gt
" [default] vnoremap <ESC>[6;5~   <ESC>gt
" [default] inoremap <ESC>[6;5~   <C-o>gt

""" with Ctrl-Shift, go to last tab page
" <C-S-PageDown>
nnoremap <ESC>[6;6~   :tablast<CR>
vnoremap <ESC>[6;6~   <ESC>:tablast<CR>
inoremap <ESC>[6;6~   <C-o>:tablast<CR>

""" with Alt, go window down
" <M-PageDown>
nnoremap <ESC>[6;3~   <C-w>j
vnoremap <ESC>[6;3~   <C-w>j
inoremap <ESC>[6;3~   <C-o><C-w>j

""" with Alt-Shift, go window right
" <M-S-PageDown>
nnoremap <ESC>[6;4~   <C-w>l
vnoremap <ESC>[6;4~   <C-w>l
inoremap <ESC>[6;4~   <C-o><C-w>l

""" with Alt-Ctrl, window size shorter
" <M-C-PageDown>
nnoremap <ESC>[6;7~   <C-w>-
vnoremap <ESC>[6;7~   <C-w>-
inoremap <ESC>[6;7~   <C-o><C-w>-

""" with Alt-Ctrl-Shift, window size nallower
" <M-C-S-PageDown>
nnoremap <ESC>[6;8~   <C-w><
vnoremap <ESC>[6;8~   <C-w><
inoremap <ESC>[6;8~   <C-o><C-w><

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, Up
" <Up>
" [default] nnoremap <ESC>OA as is
" [default] vnoremap <ESC>OA as is
" [default] inoremap <ESC>OA as is

""" with Shift, select region Up
" <S-Up>
" [default] nnoremap <ESC>O2A   <PageUp>
" [default] vnoremap <ESC>O2A   <PageUp>
" [default] inoremap <ESC>O2A   <C-o><PageUp>
nnoremap <ESC>O2A   vk
vnoremap <ESC>O2A   k
inoremap <ESC>O2A   <C-o>vk

""" with Ctrl, 5 lines Up
" <C-Up>
" [default] nnoremap <ESC>O5A   <PageUp>
" [default] vnoremap <ESC>O5A   <ESC>gt
" [default] inoremap <ESC>O5A   <C-o>gt
nnoremap <ESC>O5A   5k
vnoremap <ESC>O5A   5k
inoremap <ESC>O5A   <C-o>5k


""" with Ctrl-Shift, select region 5 lines Up
" <C-S-Up>
nnoremap <ESC>O6A   v5k
vnoremap <ESC>O6A   5k
inoremap <ESC>O6A   <C-o>v5k

""" with Alt, window up
" <M-Up>
nnoremap <ESC>O3A   <C-w>k
vnoremap <ESC>O3A   <C-w>k
inoremap <ESC>O3A   <C-o><C-w>k

""" with Alt-Shift, window size taller
" <M-S-Up>
nnoremap <ESC>O4A   <C-w>+
vnoremap <ESC>O4A   <C-w>+
inoremap <ESC>O4A   <C-o><C-w>+

""" with Alt-Ctrl, nop
" <M-C-Up>
nnoremap <ESC>O7A   <nop>
vnoremap <ESC>O7A   <nop>
inoremap <ESC>O7A   <nop>

""" with Alt-Ctrl-Shift, nop
" <M-C-S-Up>
nnoremap <ESC>O8A   <nop>
vnoremap <ESC>O8A   <nop>
inoremap <ESC>O8A   <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, Down
" <Up>
" [default] nnoremap <ESC>OB as is
" [default] vnoremap <ESC>OB as is
" [default] inoremap <ESC>OB as is

""" with Shift, Down
" <S-Up>
" [default] nnoremap <ESC>O2B   <PageDown>
" [default] vnoremap <ESC>O2B   <PageDown>
" [default] inoremap <ESC>O2B   <C-o><PageDown>
nnoremap <ESC>O2B   vj
vnoremap <ESC>O2B   j
inoremap <ESC>O2B   <C-o>vj

""" with Ctrl, 5 lines Down
" <C-Up>
" [default] nnoremap <ESC>O5B   <PageDown>
" [default] vnoremap <ESC>O5B   <ESC>gt
" [default] inoremap <ESC>O5B   <C-o>gt
nnoremap <ESC>O5B   5j
vnoremap <ESC>O5B   5j
inoremap <ESC>O5B   <C-o>5j


""" with Ctrl-Shift, select 5 lines Up
" <C-S-Up>
nnoremap <ESC>O6B   v5j
vnoremap <ESC>O6B   5j
inoremap <ESC>O6B   <C-o>v5j

""" with Alt, window up
" <M-Up>
nnoremap <ESC>O3B   <C-w>j
vnoremap <ESC>O3B   <C-w>j
inoremap <ESC>O3B   <C-o><C-w>j

""" with Alt-Shift, window size shorter
" <M-S-Up>
nnoremap <ESC>O4B   <C-w>-
vnoremap <ESC>O4B   <C-w>-
inoremap <ESC>O4B   <C-o><C-w>-

""" with Alt-Ctrl, nop
" <M-C-Up>
nnoremap <ESC>O7B   <nop>
vnoremap <ESC>O7B   <nop>
inoremap <ESC>O7B   <nop>

""" with Alt-Ctrl-Shift, nop
" <M-C-S-Up>
nnoremap <ESC>O8B   <nop>
vnoremap <ESC>O8B   <nop>
inoremap <ESC>O8B   <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, Right
" <Right>
" [default] nnoremap <ESC>OC as is
" [default] vnoremap <ESC>OC as is
" [default] inoremap <ESC>OC as is

""" with Shift, select region Right
" <S-Right>
" [default] nnoremap <ESC>O2C   w
" [default] vnoremap <ESC>O2C   w
" [default] inoremap <ESC>O2C   <C-o>w
nnoremap <ESC>O2C   vl
vnoremap <ESC>O2C   l
inoremap <ESC>O2C   <C-o>vl

""" with Ctrl, 5 chars Right
" <C-Right>
" [default] nnoremap <ESC>O5C   w
" [default] vnoremap <ESC>O5C   w
" [default] inoremap <ESC>O5C   <C-o>w
nnoremap <ESC>O5C   5l
vnoremap <ESC>O5C   5l
inoremap <ESC>O5C   <C-o>v5l


""" with Ctrl-Shift, select region 5 lines Up
" <C-S-Right>
nnoremap <ESC>O6C   v5l
vnoremap <ESC>O6C   5l
inoremap <ESC>O6C   <C-o>5l

""" with Alt, window up
" <M-Right>
nnoremap <ESC>O3C   <C-w>l
vnoremap <ESC>O3C   <C-w>l
inoremap <ESC>O3C   <C-o><C-w>l

""" with Alt-Shift, window size wider
" <M-S-Right>
nnoremap <ESC>O4C   <C-w>>
vnoremap <ESC>O4C   <C-w>>
inoremap <ESC>O4C   <C-o><C-w>>

""" with Alt-Ctrl, window size shorter
" <M-C-Right>
nnoremap <ESC>O7C   <nop>
vnoremap <ESC>O7C   <nop>
inoremap <ESC>O7C   <nop>

""" with Alt-Ctrl-Shift, window size nallower
" <M-C-S-Right>
nnoremap <ESC>O8C   <nop>
vnoremap <ESC>O8C   <nop>
inoremap <ESC>O8C   <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" without modifier, Left
" <Left>
" [default] nnoremap <ESC>OD as is
" [default] vnoremap <ESC>OD as is
" [default] inoremap <ESC>OD as is

""" with Shift, select region Left
" <S-Left>
" [default] nnoremap <ESC>O2D   b
" [default] vnoremap <ESC>O2D   b
" [default] inoremap <ESC>O2D   <C-o>b
nnoremap <ESC>O2D   vh
vnoremap <ESC>O2D   h
inoremap <ESC>O2D   <C-o>vh

""" with Ctrl, 5 chars Left
" <C-Left>
" [default] nnoremap <ESC>O5D   b
" [default] vnoremap <ESC>O5D   b
" [default] inoremap <ESC>O5D   <C-o>b
nnoremap <ESC>O5D   5h
vnoremap <ESC>O5D   5h
inoremap <ESC>O5D   <C-o>v5h


""" with Ctrl-Shift, select region 5 lines Up
" <C-S-Left>
nnoremap <ESC>O6D   v5h
vnoremap <ESC>O6D   5h
inoremap <ESC>O6D   <C-o>v5h

""" with Alt, window up
" <M-Left>
nnoremap <ESC>O3D   <C-w>h
vnoremap <ESC>O3D   <C-w>h
inoremap <ESC>O3D   <C-o><C-w>h

""" with Alt-Shift, window size wider
" <M-S-Left>
nnoremap <ESC>O4D   <C-w><
vnoremap <ESC>O4D   <C-w><
inoremap <ESC>O4D   <C-o><C-w><

""" with Alt-Ctrl, window size shorter
" <M-C-Left>
nnoremap <ESC>O7D   <nop>
vnoremap <ESC>O7D   <nop>
inoremap <ESC>O7D   <nop>

""" with Alt-Ctrl-Shift, window size nallower
" <M-C-S-Left>
nnoremap <ESC>O8D   <nop>
vnoremap <ESC>O8D   <nop>
inoremap <ESC>O8D   <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" keys with Leader

let mapleader = "\<Space>"

" toggle highlight search
nnoremap <silent> <Leader><Leader> :set hlsearch!<CR>
vnoremap <silent> <Leader><Leader> :<C-u>set hlsearch!<CR>gv
" execute selected command
nnoremap <Leader><CR>     V:!/usr/bin/env bash
vnoremap <Leader><CR>     :!/usr/bin/env bash

" reload .vimrc
nnoremap <silent> <Leader>rr :source ~/.vimrc<CR>:noh<CR>

" insert empty line
nnoremap <silent> <Leader>o o<ESC>
nnoremap <silent> <Leader>O O<ESC>
" insert empty line
nnoremap <silent> <Leader>oo :call append(line("."),   repeat([""], v:count1))<CR>
nnoremap <silent> <Leader>OO :call append(line(".")-1, repeat([""], v:count1))<CR>

" move cursor
nnoremap <Leader><Left>   ^
nnoremap <Leader><Right>  g_
nnoremap <Leader><Up>     <C-u>
nnoremap <Leader><Down>   <C-d>

" start selection
nnoremap <Leader><S-Left>   v<Left>
nnoremap <Leader><S-Right>  v<Right>
nnoremap <Leader><S-Up>     v<Up>
nnoremap <Leader><S-Down>   v<Down>


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

" window open
nnoremap <Leader>wo :sp .
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

" tab open
nnoremap <Leader>to :tabnew .
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
if &term =~ "xterm"
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
" daw              delete a word
" diW              delete inner WORD
" daW              delete a WORD
" dgn              delete next search
" dis              delete inner sentence
" das              delete a sentence
" dib              delete inner '(' ')' block
" dab              delete a '(' ')' block
" dip              delete inner paragraph
" dap              delete a paragraph
" diB              delete inner '{' '}' Block
" daB              delete a '{' '}' Block

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
