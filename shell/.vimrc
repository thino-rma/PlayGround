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
set title
set virtualedit=block
set whichwrap=b,s,[,],<,>
set wildmenu

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
nnoremap <F1> :call MapF1()<CR>
""" function for F1, toggle Help
function! MapF1()
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
"     Hint: original q/ and q? shows search history.

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

""" with Alt, search forward case sensivtive
" <M-F3>
nnoremap <ESC>[13;3~ /\c<Left><Left>
vnoremap <ESC>[13;3~ /\c<Left><Left>
inoremap <ESC>[13;3~ <ESC>/\c<Left><Left>

""" with Alt-Shift, search backword case sensitive
" <M-S-F3>
nnoremap <ESC>[13;4~ :set ignorecase!<CR>?<CR>:set ignorecase!<CR>
vnoremap <ESC>[13;4~ :set ignorecase!<CR>?<CR>:set ignorecase!<CR>
inoremap <ESC>[13;4~ <C-o>:set ignorecase!<CR><C-o>?<CR><C-o>:set ignorecase!<CR>

""" with Ctrl, confirm search forward case sensitive
" <C-F3>
nnoremap <ESC>[13;5~ /<C-r>/\C<Left><Left>
vnoremap <ESC>[13;5~ /<C-r>/\C<Left><Left>
inoremap <ESC>[13;5~ <C-o>/<C-r>/\C<Left><Left>

""" with Ctrl-Shift, confirm search backward case sensitive
" <C-S-F3>
nnoremap <ESC>[13;6~ ?<C-r>/\C<Left><Left>
vnoremap <ESC>[13;6~ ?<C-r>/\C<Left><Left>
inoremap <ESC>[13;6~ <C-o>?<C-r>/\C<Left><Left>

""" with Alt-Ctrl, N/A
" <M-C-F3>
nnoremap <ESC>[13;7~ <nop>
vnoremap <ESC>[13;7~ <nop>
inoremap <ESC>[13;7~ <nop>

""" with Alt-Ctrl, N/A
" <M-C-S-F3> substitute
nnoremap <ESC>[13;8~ <nop>
vnoremap <ESC>[13;8~ <nop>
inoremap <ESC>[13;8~ <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F4  substitute commands.
"     Hint: original q: shows command history (includes substitute).
"     Caution: F4 and S-F4 have same mapping
"              M-F4 and M-S-F4 have same mapping

""" without modifire, repeat last substitute
" F4     
nnoremap <F4>        &
vnoremap <F4>        &
inoremap <F4>        <C-o>&

""" with Shift, repeat last substitute
" <S-F4>
nnoremap <S-F4>      &
vnoremap <S-F4>      &
inoremap <S-F4>      <C-o>&

""" with Alt, repeat last substitute, case sensitive
" <M-F4>
nnoremap <ESC>[14;3~ :set ignorecase!<CR>&<CR>:set ignorecase!<CR>
vnoremap <ESC>[14;3~ <nop>
inoremap <ESC>[14;3~ <C-o>:set ignorecase!<CR><C-o>&<CR><C-o>:set ignorecase!<CR>

""" with Alt-Shift, repeat last substitute, case sensitive
" <M-S-F4>
nnoremap <ESC>[14;4~ :set ignorecase!<CR>&<CR>:set ignorecase!<CR>
vnoremap <ESC>[14;4~ <nop>
inoremap <ESC>[14;4~ <C-o>:set ignorecase!<CR><C-o>&<CR><C-o>:set ignorecase!<CR>

""" with Ctrl, confirm substitute /, waiting for {string}<CR>
" <C-F4>
nnoremap <ESC>[14;5~ :s/<C-r>///<Left>
vnoremap <ESC>[14;5~ <nop>
inoremap <ESC>[14;5~ <C-o>:s/<C-r>///<Left>

""" with Ctrl-Shift, confirm substitute #, waiting for {string}<CR>
" <C-S-F4>
nnoremap <ESC>[14;6~ :s#<C-r>/##<Left>
vnoremap <ESC>[14;6~ <nop>
inoremap <ESC>[14;6~ <C-o>:s#<C-r>/##<Left>

""" with Meta-Ctrl, confirm substitute /, waiting for {pattern}<CR>
" <M-C-F4>
nnoremap <ESC>[14;7~ :s//~/<Left><Left><Left>
vnoremap <ESC>[14;7~ <nop>
inoremap <ESC>[14;7~ <C-o>:s//~/<Left><Left><Left>

""" with Meta-Ctrl-Shift, confirm substitute #, waiting for {pattern}<CR>
" <M-C-S-F4>
nnoremap <ESC>[14;8~ :s##~#<Left><Left><Left>
vnoremap <ESC>[14;8~ <nop>
inoremap <ESC>[14;8~ <C-o>:s##~#<Left><Left><Left>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F5  yank / visual selection

""" without modifier, yank internal word
" <F5>
nnoremap <F5>       yiw

""" with Shift, yank internal WORD
" <S-F5>
nnoremap <S-F5>     yiW

""" with Meta, yank to end of the line (printable)
" <M-F5>
nnoremap <M-F5>     yg_

""" with Meta-Shift, yank to end of the line
" <M-S-F5>
nnoremap <M-S-F5>   y$

""" with Ctrl, select internal word
" <C-F5>
nnoremap <C-F5>     viw

""" with Ctrl-Shift, select internal WORD
" <M-S-F5>
nnoremap <C-S-F5>   viW

""" with Meta, yank to end of the line (printable)
" <M-C-F5>
nnoremap <M-C-F5>   vg_

""" with Meta-Shift, yank to end of the line
" <M-C-S-F5>
nnoremap <M-C-S-F5> v$

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F6  replace

" F6
nnoremap <F6>           viwP
nnoremap <S-F6>         viWP
nnoremap <M-F6>         vg_P
nnoremap <M-S-F6>       v$P
nnoremap <C-F6>         v0P
nnoremap <C-S-F6>       VP
nnoremap <M-C-F6>       <nop>
nnoremap <M-C-S-F6>     <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F7  f<C-k> and F<C-k> / (Alt) t<C-k> and T<C-k>

" F7
nnoremap <F7>           f<C-k>
nnoremap <S-F7>         F<C-k>
nnoremap <M-F7>         t<C-k>
nnoremap <M-S-F7>       T<C-k>
nnoremap <C-F7>         f<C-k>j
nnoremap <C-S-F7>       F<C-k>j
nnoremap <M-C-F7>       t<C-k>j
nnoremap <M-C-S-F7>     T<C-k>j

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

" F9
nnoremap <F9>           gt
nnoremap <S-F9>         gT
nnoremap <M-F9>         <C-w>w
nnoremap <M-S-F9>       <C-w>W
nnoremap <C-F9>         :tablast
nnoremap <C-S-F9>       :tabfirst
nnoremap <M-C-F9>       <C-w>r
nnoremap <M-C-S-F9>     <C-w>R

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F10  nop

" F10 
nnoremap <F10>           <nop>
nnoremap <S-F10>         <nop>
nnoremap <A-F10>         <nop>
nnoremap <S-A-F10>       <nop>
nnoremap <C-F10>         <nop>
nnoremap <C-S-F10>       <nop>
nnoremap <C-A-F10>       <nop>
nnoremap <C-S-A-F10>     <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" F11  nop

" F11
nnoremap <F11>           <nop>
nnoremap <S-F11>         <nop>
nnoremap <A-F11>         <nop>
nnoremap <S-A-F11>       <nop>
nnoremap <C-F11>         <nop>
nnoremap <C-S-F11>       <nop>
nnoremap <C-A-F11>       <nop>
nnoremap <C-S-A-F11>     <nop>

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
nnoremap <silent> <S-F12> <ESC>:<C-u>let &scrolloff=999-&scrolloff<CR>:echo "scrolloff = " . &scrolloff<CR>
inoremap <silent> <S-F12> <C-o>:let &scrolloff=999-&scrolloff<CR><C-o>:echo "scrolloff = " . &scrolloff<CR>

""" with Ctrl, Toggle cursorline, cursorcol (Ctrl = Cursorline, Cursorcol)
" <C-F12>
nnoremap <silent> <C-F12> <ESC>:set cursorline!<CR>:set cursorcolumn!<CR>
inoremap <silent> <C-F12> <C-o>:set cursorline!<CR><C-o>:set cursorcolumn!<CR>

""" with Ctrl+Shift
" <C-S-F12>
noremap <C-S-F12>       <nop>

""" with Alt
" <M-F12>
noremap <M-F12>         <nop>

""" with Alt-Shift
" <M-S-F12>
noremap <M-S-F12>       <nop>

""" with Alt-Ctrl
" <M-C-F12>
noremap <M-C-F12>       <nop>

""" with Alt-Ctrl-Shift
" <M-C-S-F12>
noremap <M-C-S-F12>     <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Insert> modifire is disabled in RLogin
" <S-Insert> RLogin PASTE
" nnoremap <ESC>[2;2    NOT AVAILABLE
" <M-Insert>
" nnoremap <ESC>[2;3    gt
" <M-S-Insert>
" nnoremap <ESC>[2;4    gt
" <C-Insert>
" nnoremap <ESC>[2;5    gt
" <C-S-Insert>
" nnoremap <ESC>[2;6    gt
" <M-C-Insert>
" nnoremap <ESC>[2;7    gt
" <M-C-S-Insert>
" nnoremap <ESC>[2;8    gt

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
nnoremap <ESC>[3;2~   x
nnoremap <ESC>[3;2~   x

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
" [default] nnoremap <End>   $
" [default] vnoremap <End>   $
" [default] inoremap <End>   <C-o>$

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

""" with Meta, go window up
" <M-PageUp>
nnoremap <ESC>[5;3~   <C-w>k
vnoremap <ESC>[5;3~   <C-w>k
inoremap <ESC>[5;3~   <C-o><C-w>k

""" with Meta-Shift, go window keft
" <M-S-PageUp>
nnoremap <ESC>[5;4~   <C-w>h
vnoremap <ESC>[5;4~   <C-w>h
inoremap <ESC>[5;4~   <C-o><C-w>h

""" with Meta-Ctrl, window size highter
" <M-C-PageUp>
nnoremap <ESC>[5;7~   <C-w>+
vnoremap <ESC>[5;7~   <C-w>+
inoremap <ESC>[5;7~   <C-o><C-w>+

""" with Meta-Ctrl-Shift, window size wider
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

""" with Meta, go window down
" <M-PageDown>
nnoremap <ESC>[6;3~   <C-w>j
vnoremap <ESC>[6;3~   <C-w>j
inoremap <ESC>[6;3~   <C-o><C-w>j

""" with Meta-Shift, go window right
" <M-S-PageDown>
nnoremap <ESC>[6;4~   <C-w>l
vnoremap <ESC>[6;4~   <C-w>l
inoremap <ESC>[6;4~   <C-o><C-w>l

""" with Meta-Ctrl, window size shorter
" <M-C-PageDown>
nnoremap <ESC>[6;7~   <C-w>-
vnoremap <ESC>[6;7~   <C-w>-
inoremap <ESC>[6;7~   <C-o><C-w>-

""" with Meta-Ctrl-Shift, window size nallower
" <M-C-S-PageDown>
nnoremap <ESC>[6;8~   <C-w><
vnoremap <ESC>[6;8~   <C-w><
inoremap <ESC>[6;8~   <C-o><C-w><

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
" enter digraph    <C-@>{char1}{char2}
cnoremap <C-@>  <C-k>

cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-a> <Home>
cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>
cnoremap <C-d> <Del>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" keys with Leader

let mapleader = "\<Space>"

" toggle highlight search
nnoremap <Leader><Leader> :set hlsearch!<CR>

" reload .vimrc
nnoremap <silent> <Leader>rr :source ~/.vimrc<CR>:noh<CR>

" insert empty line
nnoremap <silent> <Leader><CR> o<ESC>
nnoremap <silent> <Leader>o o<ESC>
nnoremap <silent> <Leader>O O<ESC>

" move cursor
nnoremap <Leader><Left>   ^
nnoremap <Leader><Right>  g_
nnoremap <Leader><Up>     <C-u>
nnoremap <Leader><Down>   <C-d>

" Quickly move to the beginning of line
nnoremap <Leader><C-a> 0
" Move to the end of line
nnoremap <Leader><C-e> g_
" Delete all characters after the cursor (Kills forward)
nnoremap <Leader><C-k> dg_
" Delete all characters before the cursor (Kills backward)
nnoremap <Leader><C-u> d0

" open window
nnoremap <Leader>ow :sp .
" open tab
nnoremap <Leader>ot :tabnew .

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

" table next/previous
nnoremap <Leader>tt gt
nnoremap <Leader>tT gT
" table rotate
nnoremap <Leader>tr :tabmove<CR>gt

" find (uses "f in visual mode)
nnoremap <Leader>f /<C-r>/
vnoremap <Leader>f "fy/<C-r>f
nnoremap <Leader>F /<C-r>/\C<Left><Left>
vnoremap <Leader>F "fy/<C-r>f\C<Left><Left>

" replace (uses "r in visual mode)
nnoremap <Leader>r :s/<C-r>///<Left>
vnoremap <Leader>r "ry:s/<C-r>r//<Left>
nnoremap <Leader>R :s/<C-r>///I<Left><Left>
vnoremap <Leader>R "ry:s/<C-r>r//I<Left><Left>

" list registries/tabs/buffers
nnoremap <Leader>lr :reg<CR>
nnoremap <Leader>lt :tabs<CR>
nnoremap <Leader>lb :buffers<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Leader for digraph

" use digraph {x}{x}
nnoremap <Leader>@f f<C-k>
vnoremap <Leader>@f f<C-k>
nnoremap <Leader>@t t<C-k>
vnoremap <Leader>@t t<C-k>
" use digraph j{x}
vnoremap <Leader><C-@><C-f> f<C-k>j
vnoremap <Leader><C-@><C-f> f<C-k>j
nnoremap <Leader><C-@><C-t> t<C-k>j
vnoremap <Leader><C-@><C-t> t<C-k>j
" for common usage in command-line mode
nnoremap <Leader>@     <C-k>
vnoremap <Leader>@     <C-k>
nnoremap <Leader><C-@> <C-k>
vnoremap <Leader><C-@> <C-k>

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
