" vim: foldmethod=marker :
"
set nocompatible

" Include pathogen
call pathogen#infect()
call pathogen#helptags()

" {{{ Window and editor setup

" Display line numbers and rulers.
set number
set ruler
syntax on

" Set encoding
set encoding=utf-8

" Use 256 colors
set t_Co=256

let mapleader=','

" Whitespace features
set tabstop=4
set shiftwidth=4
set softtabstop=4
set list listchars=tab:▸\ ,eol:¬,trail:·
set noeol
set autoindent
set expandtab

" Enable formatting of comments, and one letter words.
" see :help fo-table
set formatoptions=qrc1

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Window settings
set wrap
set lbr
set textwidth=0
set cursorline

" Don't redraw when macros are executing.
set lazyredraw

" Use modeline overrides
set modeline
set modelines=10

" Status bar
set laststatus=2

" Use the system clipboard
set clipboard=unnamed

" Enable folding via `{{{` and  `}}}`
set foldmethod=marker

" Use new regex engine to get better performance in ruby files
set regexpengine=2 "

" Tab completion for filenames and other command line features.
set wildmenu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.pyc,node_modules/*

" }}}

" {{{ Colors and cursors

" Default color scheme
set background=light
set noshowmode
let g:solarized_visibility='medium'
let g:solarized_contrast='normal'
color solarized

" Context-dependent cursor in the terminal
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7""

" }}}

" {{{ Swap files and undos

" Swap files. Generally things are in version control
" don't use backupfiles either.
set noswapfile
set nobackup
set nowritebackup

" Persistent undos
if !&diff
  set undodir=~/.vim/backup
  set undofile
endif

" }}}

" {{{ Searching
"
set hlsearch
set incsearch
set ignorecase
set smartcase
set gdefault
nnoremap / /\v
vnoremap / /\v
set grepprg=ack\ --column
set grepformat=%f:%l:%c:%m

" Clear search highlighting
map <Leader><Space> :nohl<CR>

" }}}

" Spell checking. configure the language and turn off spell checking.
set spell spelllang=en_ca
set nospell


" Autoclose terminal compatibility
if !has('gui_running')
	let g:AutoClosePreservDotReg = 0
endif


" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" {{{ Autocommands
"
" Save on blur
au FocusLost * :wa

" Save on blur for terminal vim
au CursorHold,CursorHoldI * silent! wa

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" }}}

" {{{ Filetypes
"
" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" make uses real tabs
au FileType make setl noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby

" Map .twig files as jinja templates
au BufRead,BufNewFile *.twig,*.tpl set ft=htmljinja

" Map *.coffee to coffee type
au BufRead,BufNewFile *.coffee set ft=coffee

" Highlight JSON & es6 like Javascript
au BufNewFile,BufRead {*.json,*.es6} set ft=javascript

" hbs and mustache files.
au BufRead,BufNewFile {*.mustache,*.hbs} set ft=mustache

" Jenkinsfile are groovy
au BufRead,BufNewFile Jenkinsfile set ft=groovy

" Lector uses custom file types, but markdown contents.
au BufNewFile,BufRead {*.lr} set ft=markdown

" make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python setl softtabstop=4 shiftwidth=4 tabstop=4 textwidth=100 colorcolumn=99
au FileType rst setl textwidth=80 colorcolumn=81

" Make ruby,scss,sass,less use 2 spaces for indentation.
au FileType {cucumber,yaml,sass,scss,ruby,eruby,less} setl softtabstop=2 shiftwidth=2 tabstop=2 colorcolumn=100

" php settings
au FileType php setl textwidth=120 softtabstop=4 shiftwidth=4 tabstop=4 colorcolumn=120

" golang settings
au FileType go setl textwidth=120 softtabstop=4 shiftwidth=4 tabstop=4 noexpandtab colorcolumn=100

" markdown settings
au FileType markdown setl textwidth=80 softtabstop=4 shiftwidth=4 tabstop=4 colorcolumn=79

" Javascript, CSS, and html settings
au FileType {css,typescript,javascript,mustache,htmljinja,html} setl textwidth=120 softtabstop=2 shiftwidth=2 tabstop=2 colorcolumn=120

" CoffeeScript, Groovy, Elm, Docker
au FileType {coffee,groovy,elm,dockerfile} setl textwidth=100 softtabstop=2 shiftwidth=2 tabstop=2 colorcolumn=100

" }}}

" {{{ Keybindings

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Remap j/k for long line situations
nmap j gj
nmap k gk

" Remap keys for split window ease of use.
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l
nmap <Leader>j <C-W>j
nmap <Leader>k <C-W>k
nmap <Leader>h <C-W>h
nmap <Leader>l <C-W>l

" Adjust viewports/splits to be the same size.
map <Leader>= <C-w>=
imap <Leader>= <Esc> <C-w>=

" Lazy save / save + exit
map <Leader>w :w<CR>
map <Leader>q :q<CR>

" I can't type, fix common mistakes.
cmap W<CR> w<CR>
cmap Wq<CR> wq<CR>
cmap Q<CR> q<CR>
cmap Qa<CR> qa<CR>

" Move to occurances
map <Leader>f [I:let nr = input("Which one:")<Bar>exe "normal " . nr . "[\t"<CR>

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Mouse scrolling in a terminal
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" Turn off Ex mode - I hate that thing.
nnoremap Q <nop>

" }}}

" {{{ Custom commands
"

" XML Tidying
:command Txml :%!tidy -q -i -xml

" Spell check shortcut.
:command SpellOn :setlocal spell spelllang=en_ca

:command SpellOff :setlocal nospell

" Trim whitespace
:command Trim :%s/\s\+$//e

" CTags
" Generate ctags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

nmap <Leader>gs :Gstat<CR>

" Go to the next tag.
map <C-\> :tnext<CR>

" Add w!! - sudo save
cmap w!! w !sudo tee % >/dev/null
" }}}

" {{{ Plugin config

" ZoomWin configuration
map <Leader>z :ZoomWin<CR>

" CTags
let g:tlist_php_settings = 'php;c:class;d:constant;f:function'

" NERDTree configuration
let NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$']
map <Leader>n :NERDTreeToggle<CR>

" Leader-/ to toggle comments
map <Leader>/ <plug>NERDCommenterToggle<CR>
imap <Leader>/ <Esc><plug>NERDCommenterToggle<CR>i

" Command-T configuration
let g:CommandTMaxHeight=20

" RagTag
let g:ragtag_global_maps = 1

" Configure a.l.e. syntax checking
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8'],
\}
" Only lint on save.
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0

" Customize flags
let g:ale_sign_error = '✖︎'
let g:ale_sign_warning = '❢'

" Enable virtual text display
let g:ale_virtualtext_cursor = 1


" Ack plugin
map <Leader>a :Ack<Space>

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline_theme='solarized'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_symbols = {}
let g:airline_symbols.linenr = '␊ '
let g:airline_symbols.branch = '⎇ '
let g:airline_solarized_reduced = 0
" Only show the column number.
let g:airline_section_z = 'c:%c'
" Use short forms for common modes.
let g:airline_mode_map = {
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'v'  : 'V',
    \ 's'  : 'S',
    \ 't'  : 'T',
    \ }


" Fuzzy finder depends on `brew install fzf`
set rtp+=/usr/local/opt/fzf
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_tags_command = 'ctags --extra=+f -R'
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

nmap <Leader>t :Files<CR>
nmap <Leader>b :Buffers<CR>
" }}}

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" Configure paths for Vdebug
" Paths maps are remote: local
let g:vdebug_options = {
\ 'path_maps': {"/mnt/hgfs/Sites/fresh_app": "/Users/mark/Sites/fresh_app"},
\ 'server': '0.0.0.0'
\}


" Load vimrc in each directory that vim is opened in.
" This provides 'per project' vim config.
set exrc
