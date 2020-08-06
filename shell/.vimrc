" $ curl https://raw.githubusercontent.com/thino-rma/PlayGround/master/shell/.vimrc -o ~/.vimrc
" $ wget https://raw.githubusercontent.com/thino-rma/PlayGround/master/shell/.vimrc -O ~/.vimrc

""" this option is useless.
set nocompatible

"=== for vim ===========================================================

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

""" set terminal visual bell
set vb t_vb=

""" if vim.tine then execute it.
silent! while 0
  noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>
  """ finish reading vimrc
  finish
silent! endwhile

"=== for vim ===========================================================

set clipboard=unnamedplus
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

" imap <C-j> <C-[>   " Ctrl-j
" inoremap jk <ESC>  " jk is senseless.
" let mapleader = ' '

if has('mouse')
  set mouse=a
  noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>:exec &mouse! = '' ? set mouse= : set mouse=a<CR>
else
  noremap <silent> <F12> <ESC>:set number!<CR>:set list!<CR>
endif


" https://stackoverflow.com/questions/43654089/vim-mapping-q-only-when-not-recording
function! s:AltRecord(reg, len)
  if exists("g:recording_macro")
    let r = g:recording_macro
    unlet g:recording_macro
    normal! q
    execute 'let @'.r." = @".r.'[:-'.len.']'
  else
    let c = nr2char(getchar())
    if c == ':'
       quit
    else
       let g:recording_macro = reg
       execute 'normal! q'.reg
    endif
  endif
endfunction
nnoremap Q q
nnoremap q <Nop>
noremap <S-F1> :<C-u>call <SID>AltRecord('a', 2)<CR>
function! s:Sample(reg)
  execute 'let @'.reg." = 'test'"
endfunction
nnoremap <S-F1> :<C-u>call <SID>Sample('a')<CR>


" ======================================================================
""" usage """

" :%s/abc/xyz/gcI  global / confirm / case sensitive
" I xyz ESC .      repeat input commands 
" C-v ... xyz      BLOCK VISUAL selection input (multi cursor)

""" (1) mode, save/quit
" i / a / o           enter INPUT mode. INPUT / APPEND / OPEN bottom
" I / A / O           enter INPUT mode at HEAD / END / OPEN upper
" v / S-v / C-v       enter VISUAL mode. VISUAL / LINE VISUAL / BLOCK VISUAL
" ESC                 back to NORMAL mode.
" u / C-r / .         Undo / Redo / repeat
" :w [filename]<CR>   write to file
" :q<CR>, :q!<CR>    quit (or close current tab/window) / quit force
" :wq<CR>, ZZ<CR>    write and quit (or close current tab/window)

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


""" check key code
" $ sed -n l
" exit with Ctrl-D or Ctrl-C
