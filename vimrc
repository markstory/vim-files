" vim: foldmethod=marker :
"
set nocompatible

" {{{ Plugin installation
call plug#begin()

" Text manipulation
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Townk/vim-autoclose'

Plug 'duff/vim-scratch'
Plug 'markstory/vim-zoomwin'

" Search and nav
Plug 'mileszs/ack.vim'
Plug 'lambdalisue/fern.vim'
Plug 'ddollar/nerdcommenter'
Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'vimwiki/vimwiki'

" Autocomplete and linting
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}

" Languages
Plug 'vim-scripts/php.vim--Garvin'
Plug 'joonty/vdebug'
Plug 'timcharper/textile.vim'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-markdown'
Plug 'groenewege/vim-less'
Plug 'jnwhiteh/vim-golang', { 'for': 'go' }
Plug 'mustache/vim-mustache-handlebars'
Plug 'wting/rust.vim', { 'for': 'rust' }
Plug 'honza/dockerfile.vim'
Plug 'vim-scripts/groovy.vim', { 'for': 'groovy' }
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'mitsuhiko/vim-jinja'
Plug 'HerringtonDarkholme/yats.vim'

" Not currently working with these languages
" Keeping them out of laziness.
" Plug 'elixir-editors/vim-elixir', { 'for': 'elixir' }
" Plug 'arrufat/vala.vim'

" Visuals
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()
" }}}


" {{{ Window and editor setup

" Display line numbers and rulers.
set number
set ruler
syntax on

" Set encoding
set encoding=utf-8

let mapleader=','

" Whitespace features
set tabstop=4
set shiftwidth=4
set softtabstop=4
set list listchars=tab:▸\ ,trail:·
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

" Use modeline overrides
set modeline
set modelines=10

" Status bar
set laststatus=2

" Auto load changes outside of vim
set autoread

" Use the system clipboard
if has('macunix')
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

" Enable folding via `{{{` and  `}}}`
set foldmethod=marker
set foldlevelstart=1

" Try rendering tweaks
set ttyfast
set lazyredraw

" }}}

" {{{ Colors and cursors

" Default color scheme
set noshowmode
set termguicolors
set background=light

color base16_one_light

" Set cursor shaping.
" Setting colors on n-v-c causes text inside the
" cursor to disappear in alacritty.
set guicursor=n-v-c:block,i-ci-ve:ver25-Cursor,r-cr:hor20-Cursor,o:hor50-Cursor

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

" {{{ Autocommands

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
au BufNewFile,BufRead {*.es6} set ft=javascript

" hbs and mustache files.
au BufRead,BufNewFile {*.mustache,*.hbs} set ft=mustache

" Jenkinsfile are groovy
au BufRead,BufNewFile Jenkinsfile set ft=groovy

" Lector and Gatsby use custom file types, but markdown contents.
au BufNewFile,BufRead {*.mdx,*.lr} set ft=markdown

" make python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python setl softtabstop=4 shiftwidth=4 tabstop=4 textwidth=100 colorcolumn=99
au FileType rst setl textwidth=80 colorcolumn=81 shiftwidth=4 softtabstop=4 tabstop=4

" Make ruby,scss,sass,less use 2 spaces for indentation.
au FileType {cucumber,yaml,sass,scss,ruby,eruby,less} setl softtabstop=2 shiftwidth=2 tabstop=2 colorcolumn=100

" php settings
au FileType php setl textwidth=120 softtabstop=4 shiftwidth=4 tabstop=4 colorcolumn=120

" golang settings
au FileType go setl textwidth=120 softtabstop=4 shiftwidth=4 tabstop=4 noexpandtab colorcolumn=100

" markdown settings
au FileType markdown setl textwidth=80 softtabstop=4 shiftwidth=4 tabstop=4 colorcolumn=79

" Javascript, CSS, and html settings
au FileType {css,javascriptreact,typescriptreact,typescript,javascript,mustache,htmljinja,html} setl textwidth=120 softtabstop=2 shiftwidth=2 tabstop=2 colorcolumn=120

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
nmap <Leader>= <C-w>=

" Lazy save / save + exit
map <Leader>w :w<CR>
nmap <Leader>w :w<CR>
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

" Diff mappings
nnoremap dgh :diffget //2<CR>
nnoremap dgb :diffget //3<CR>

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

" Add w!! - sudo save
cmap w!! w !sudo tee % >/dev/null
" }}}

" {{{ Plugin config

" Fern
map <Leader>n :Fern . -drawer<CR>
map <Leader>nr :Fern . -drawer -reveal=%<CR>

" Format fern windows.
autocmd FileType fern set nonumber signcolumn=no

" Leader-/ to toggle comments
map <Leader>/ <plug>NERDCommenterToggle<CR>
imap <Leader>/ <Esc><plug>NERDCommenterToggle<CR>i

" RagTag
let g:ragtag_global_maps = 1

" vimwiki
let g:vimwiki_list = [{ 'path': '~/Dropbox/vimwiki/' }]
" Disable the default bindings as they make ,w slow
let g:vimwiki_key_mappings = { 'global': 0, }
:command Wiki :VimwikiIndex
:command Diary :VimwikiDiaryIndex
:command DiaryNote :VimwikiMakeDiaryNote

" Ack plugin
map <Leader>a :Ack<Space>
" Use the_silver_searcher if available
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" {{{ Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1

let g:airline_theme='base16_one_light'

let g:airline_left_sep=""
let g:airline_right_sep=""
let g:airline_symbols = {}
let g:airline_symbols.paste = "\uF691"
let g:airline_symbols.linenr = "\uE0A1"
let g:airline_symbols.branch = "\uF126"
let g:airline_symbols.readonly = "\uE0A2"
let g:airline_symbols.whitespace = "Ξ"
let g:airline_symbols.notexists = "\uF128"

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
" }}}

" {{{ fzf
" Fuzzy finder depends on `brew install fzf` or git install for linux.
if has('macunix')
    set rtp+=/usr/local/opt/fzf
else
    set rtp+=~/.fzf
endif

let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'bg+':     ['fg', 'IncSearch'],
  \ 'hl':      ['fg', 'Question'],
  \ 'hl+':     ['fg', 'Question'],
  \ 'info':    ['fg', 'Label'],
  \ 'border':  ['bg', 'CursorLine'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Special'],
  \ 'marker':  ['fg', 'Special'],
  \ 'spinner': ['fg', 'Speical'],
  \ 'header':  ['fg', 'Include'] }

" fzf on the bottom 40% of the screen
let g:fzf_layout = { 'down': '40%' }

nmap <Leader>t :Files<CR>
nmap <Leader>b :Buffers<CR>

" Disable statusline for fzf terminal window as it is noisy.
if has('nvim')
  autocmd! FileType fzf
  autocmd FileType fzf set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif
" }}}

" {{{ Completion (coc)
let g:coc_global_extensions = [
\'coc-eslint',
\'coc-json',
\'coc-phpls',
\'coc-pyright',
\'coc-tsserver',
\'coc-diagnostic',
\]

" Set node path as system node is sometimes 10.x which is incompatible with
" pyright
let g:coc_node_path = '~/.volta/tools/image/node/12.18.4/bin/node'

" Diagnostic messages show for less time
set updatetime=300
" don't show |ins-completion-menu| messages
set shortmess+=c

" Enable airline integration
let g:airline#extensions#coc#enabled = 1
let airline#extensions#coc#error_symbol = "\uf467 "
let airline#extensions#coc#warning_symbol = "\uf071 "

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Scroll floating windows
nnoremap <expr><C-b> coc#float#has_float() ? coc#float#scroll(1) : "\<C-b>"

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Bind a commands for common CoC actions/commands
" Having eslint fixing on by default disrupts `:Ack` results.
:command Fix :call CocAction('format')

" Make shorter to type commands.
:command PySort :CocCommand python.sortImports

" }}}
" }}}

" Configure paths for Vdebug
" Paths maps are remote: local
let g:vdebug_options = {
\ 'server': '0.0.0.0'
\}


" Load vimrc in each directory that vim is opened in.
" This provides 'per project' vim config.
set exrc
