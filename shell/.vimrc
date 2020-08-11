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

""" function for F1, toggle Help
function! MapF1()
  if &buftype == "help"
    exec 'quit'
  else
    exec 'help'
  endif
endfunction

" Disable F1 Help, show infomation at the cursor position
nnoremap <F1> :call MapF1()<CR>
vnoremap <F1> <Esc>g<C-g>
inoremap <F1> <Esc>g<C-g>

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

" search next/previous (zz: redraw, cursor line at center of window)
nnoremap <F3>   nzz
vnoremap <F3>   nzz
inoremap <F3>   <C-o>n<C-o>zz
" <S-F3>
nnoremap <S-F3> Nzz
vnoremap <S-F3> Nzz
inoremap <S-F3> <C-o>n<C-o>zz
" <M-f3>   search foward case sensivtive
nnoremap <ESC>[13;3~ /\c<Left><Left>
vnoremap <ESC>[13;3~ /\c<Left><Left>
inoremap <ESC>[13;3~ <ESC>/\c<Left><Left>
" <M-S-f3> search backword case sensitive
nnoremap <ESC>[13;4~ ?\c<Left><Left>
vnoremap <ESC>[13;4~ ?\c<Left><Left>
inoremap <ESC>[13;4~ <ESC>?\c<Left><Left>
" <C-f3> substitute /
nnoremap <ESC>[13;5~ :s/<C-r>///<Left>
vnoremap <ESC>[13;5~ :s/<C-r>///<Left>
inoremap <ESC>[13;5~ <ESC>:s/<C-r>///<Left>
" <C-S-f3> substitute #
nnoremap <ESC>[13;6~ :s#<C-r>/##<Left>
vnoremap <ESC>[13;6~ :s#<C-r>/##<Left>
inoremap <ESC>[13;6~ <ESC>:s#<C-r>/##<Left>
" <M-C-f3> substitute case sensitive
nnoremap <ESC>[13;7~ :s/<C-r>///i<Left><Left>
vnoremap <ESC>[13;7~ :s/<C-r>///i<Left><Left>
inoremap <ESC>[13;7~ <ESC>:s/<C-r>///i<Left><Left>
" <M-C-S-f3> substitute 
nnoremap <ESC>[13;8~ :,$s//~/gc
vnoremap <ESC>[13;8~ :s//~/gc
inoremap <ESC>[13;8~ <ESC>:,$s//~/gc

" F4
nnoremap <F4>           :&&<CR>
nnoremap <S-F4>         gt
nnoremap <A-F4>         gt
nnoremap <S-A-F4>       gt
nnoremap <C-F4>         gt
nnoremap <C-S-F4>       gt
nnoremap <C-A-F4>       gt
nnoremap <C-S-A-F4>     gt

" yank internal word / to end of the line
nnoremap <F5>       yiw
nnoremap <S-F5>     y$
nnoremap <A-F5>         gt
nnoremap <S-A-F5>       gt
nnoremap <C-F5>         gt
nnoremap <C-S-F5>       gt
nnoremap <C-A-F5>       gt
nnoremap <C-S-A-F5>     gt

" F6
nnoremap <F6>           gt
nnoremap <S-F6>         gt
nnoremap <A-F6>         gt
nnoremap <S-A-F6>       gt
nnoremap <C-F6>         gt
nnoremap <C-S-F6>       gt
nnoremap <C-A-F6>       gt
nnoremap <C-S-A-F6>     gt

" F7
nnoremap <F7>           gt
nnoremap <S-F7>         gt
nnoremap <A-F7>         gt
nnoremap <S-A-F7>       gt
nnoremap <C-F7>         gt
nnoremap <C-S-F7>       gt
nnoremap <C-A-F7>       gt
nnoremap <C-S-A-F7>     gt

" F8
nnoremap <F8>           gt
nnoremap <S-F8>         gt
nnoremap <A-F8>         gt
nnoremap <S-A-F8>       gt
nnoremap <C-F8>         gt
nnoremap <C-S-F8>       gt
nnoremap <C-A-F8>       gt
nnoremap <C-S-A-F8>     gt

" F9
nnoremap <F9>           gt
nnoremap <S-F9>         gT
nnoremap <A-F9>         gt
nnoremap <S-A-F9>       gt
nnoremap <C-F9>         gt
nnoremap <C-S-F9>       gt
nnoremap <C-A-F9>       gt
nnoremap <C-S-A-F9>     gt

" F10
nnoremap <F10>           <C-w>w
nnoremap <S-F10>         <C-w>W
nnoremap <A-F10>         gt
nnoremap <S-A-F10>       gt
nnoremap <C-F10>         gt
nnoremap <C-S-F10>       gt
nnoremap <C-A-F10>       gt
nnoremap <C-S-A-F10>     gt

" F11
nnoremap <F11>           gt
nnoremap <S-F11>         gt
nnoremap <A-F11>         gt
nnoremap <S-A-F11>       gt
nnoremap <C-F11>         gt
nnoremap <C-S-F11>       gt
nnoremap <C-A-F11>       gt
nnoremap <C-S-A-F11>     gt

" F12
""" Toggle number, list, mouse to make it easy to copy/paste
nnoremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>
inoremap <silent> <F12> <C-o>:set number!<CR><C-o>:set list!<CR>
""" Toggle cursorline, cursorcol
nnoremap <silent> <S-F12> <ESC>:set cursorline!<CR>:set cursorcolumn!<CR>
inoremap <silent> <S-F12> <C-o>:set cursorline!<CR><C-o>:set cursorcolumn!<CR>

""" Toggle number, list, mouse to make it easy to copy/paste
" if has('mouse')
"   set mouse=a
"   noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>:exec &mouse != '' ? "set mouse=" : "set mouse=a"<CR>
" else
"   noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>
" endif

nnoremap <A-F12>         gt
nnoremap <S-A-F12>       gt
nnoremap <C-F12>         gt
nnoremap <C-S-F12>       gt
nnoremap <C-A-F12>       gt
nnoremap <C-S-A-F12>     gt

let mapleader = "\<Space>"

" toggle highlight search
nnoremap <Leader><Leader> :set hlsearch!<CR>

" insert empty line
nnoremap <silent> <Leader><CR> o<ESC>
nnoremap <silent> <Leader>o o<ESC>
nnoremap <silent> <Leader>O O<ESC>

" move cursor
nnoremap <Leader><Left>   ^
nnoremap <Leader><Right>  $
nnoremap <Leader><Up>     <C-u>
nnoremap <Leader><Down>   <C-d>

" Quickly move to the beginning of line
nnoremap <Leader><C-a> 0
" Move to the end of line
nnoremap <Leader><C-e> $
" Delete all characters after the cursor (Kills foward)
nnoremap <Leader><C-k> d$
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

" find
nnoremap <Leader>f /<C-r>0
nnoremap <Leader>F /<C-r>0\C<Left><Left>
vnoremap <Leader>f "fy/<C-r>f
vnoremap <Leader>F "fy/<C-r>f\C<Left><Left>
" replace
nnoremap <Leader>r :%s/<C-r>0//gc<Left><Left><Left>
nnoremap <Leader>R :%s/<C-r>0//gcI<Left><Left><Left><Left>
vnoremap <Leader>r "ry:%s/<C-r>r//gc<Left><Left><Left>
vnoremap <Leader>R "ry:%s/<C-r>r//gcI<Left><Left><Left><Left>

" list registries/tabs/buffers
nnoremap <Leader>lr :reg<CR>
nnoremap <Leader>lt :tabs<CR>
nnoremap <Leader>lb :buffers<CR>

" find
nnoremap <Leader>f /<C-r>0\c<Left><Left>
nnoremap <Leader>F /<C-r>0\C<Left><Left>
vnoremap <Leader>f y/<C-r>0\c<Left><Left>
vnoremap <Leader>F y/<C-r>0\C<Left><Left>
" replace
nnoremap <Leader>r :%s/<C-r>0//gci<Left><Left><Left><Left>
nnoremap <Leader>R :%s/<C-r>0//gcI<Left><Left><Left><Left>
vnoremap <Leader>r y:%s/<C-r>0//gci<Left><Left><Left><Left>
vnoremap <Leader>R y:%s/<C-r>0//gcI<Left><Left><Left><Left>

" list registries/tabs/buffers
nnoremap <Leader>lr :reg<CR>
nnoremap <Leader>lt :tabs<CR>
nnoremap <Leader>lb :buffers<CR>

""" Toggle number, list, mouse to make it easy to copy/paste
nnoremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>
inoremap <silent> <F12> <C-o>:set number!<CR><C-o>:set list!<CR>

""" Toggle number, list, mouse to make it easy to copy/paste
" if has('mouse')
"   set mouse=a
"   noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>:exec &mouse != '' ? "set mouse=" : "set mouse=a"<CR>
" else
"   noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>
" endif

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

""" start/finish recording with Shift+F12 to register "a
nnoremap <S-F1> :<C-u>call <SID>AltRecord('a', 4)<CR>

""" execute macro in register "a
nnoremap <S-F2> @a


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
