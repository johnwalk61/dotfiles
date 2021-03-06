syntax on
filetype indent on
filetype plugin on

set hidden
set history=10000
set cryptmethod=blowfish2
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
set ignorecase smartcase       " make searches case-sensitive only if they contain upper-case characters
set cursorline
set switchbuf=useopen
set number
set numberwidth=5
set backspace=indent,eol,start
set showcmd                    " display incomplete commands
set nocompatible               " be iMproved
set fileformats=unix,dos,mac   " support all three, in this order
set foldmethod=syntax
set foldlevel=7
set tags=tags;
set mouse=a

" Force terminal to 256 colors
set t_Co=256
" http://vim.wikia.com/wiki/VimTip102
set omnifunc=syntaxcomplete#Complete
inoremap <tab> <c-r>=Smart_TabComplete()<CR>

" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

" Ctrl+H opens hex edit mode
nnoremap <c-h> :%!xxd<cr>

" gui colors if running iTerm
if $TERM_PROGRAM =~ "iTerm"
    set termguicolors
endif

" Use tabs with Ctrl and arrow keys, Ctrl+n to open a new tab, and Ctrl+w to
" close it
map <C-up> :tabr<cr>
map <C-down> :tabl<cr>
map <C-left> :tabp<cr>
map <C-right> :tabn<cr>
" map <C-n> :tabnew<cr>
map <C-w> :tabclose<cr>

" Ctrl-D opens a shell.
nmap <silent> <C-D> :shell<CR>

if has("gui_running")
    " setup for gui
    set guioptions-=r  " no scrollbar on the right
    set guioptions-=l  " no scrollbar on the left
    set guioptions-=m  " no menu
    set guioptions-=T  " no toolbar
    set guioptions-=L

    "if has("gui_gtk2")
    "    set guifont=Inconsolata\ 9
    "elseif has("gui_win32")
    "    set guifont=Consolas:h11:cANSI
    "else
    "    set guifont=Monaco_for_Powerline\ 9
    "endif
endif

" set theme
set background=dark 
colorscheme hybrid

" force two spaces indentation for html, ruby and python files
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype eruby setlocal ts=2 sts=2 sw=2
autocmd Filetype c setlocal ts=2 sts=2 sw=2
autocmd Filetype cpp setlocal ts=2 sts=2 sw=2

augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
augroup END

" By pressing Ctrl + R in the visual mode you will be prompted to enter text to replace with.
" Press enter and then confirm each change you agree with 'y' or decline with 'n'.
" This command will override your register 'h' so you can choose other one
" ( by changing 'h' in the command above to other lower case letter ) that you don't use.
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Initialize vundle runtime
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"
" PLUGINS
"

" Vundle package
Bundle 'gmarik/vundle'


" A file tree explorer
Bundle 'scrooloose/nerdtree'
    " Ctrl+d to toggle NerdTree
    " nmap <silent> <C-D> :NERDTreeToggle<CR>
    " Open it on vim startup
    autocmd VimEnter * NERDTree
    " Mirror tree position for every buffer
    autocmd BufEnter * NERDTreeMirror
    " Go to previous (last accessed) window ( move focus to file buffer
    " instead of the tree itself).
    autocmd VimEnter * wincmd p
    " Close nerdtree when it's the only buffer left open
    autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
    " Change dir to the dir of the new root
    let NERDTreeChDirMode = 2
    " Single click to open files and expand folders.
    let NERDTreeMouseMode = 3
    " Display hidden files
    " let NERDTreeShowHidden=1
    " Do not display these files
    " let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp']

Bundle 'octref/RootIgnore'

let loaded_netrwPlugin=1 
let NERDTreeRespectWildIgnore=1


" GIT support for NERDTree
Bundle 'Xuyuanp/nerdtree-git-plugin'
    let g:NERDTreeIndicatorMapCustom = {
        \ "Modified"  : "✹",
        \ "Staged"    : "✚",
        \ "Untracked" : "✭",
        \ "Renamed"   : "➜",
        \ "Unmerged"  : "═",
        \ "Deleted"   : "✖",
        \ "Dirty"     : "✗",
        \ "Clean"     : "✔︎",
        \ "Unknown"   : "?"
        \ }

" A much better statusline
Bundle 'Lokaltog/vim-powerline'
    " Use unicode symbols in powerline
    let g:Powerline_symbols = 'fancy'

" Sublime/Atom multi cursor selection ( CTRL+n ).
Bundle "terryma/vim-multiple-cursors"

" C+p fuzzy search
Bundle 'kien/ctrlp.vim'


"
" FUNCTIONS
"

" http://vim.wikia.com/wiki/VimTip102
function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.'))        " from the start of the current
                                                  " line to one character on
                                                  " the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction


" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction   

" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
