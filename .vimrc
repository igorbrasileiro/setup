" vim: set foldmethod=marker foldlevel=0:

let g:coc_global_extensions = [
  \'coc-tsserver',
  \'coc-eslint',
  \'coc-css',
  \'coc-json',
  \'coc-texlab',
  \'coc-vimtex',
  \'coc-rust-analyzer',
  \'@yaegassy/coc-tailwindcss3',
  \'coc-deno',
  \]

" Disable python, ruby and perl providers
" Run :checkhealth provider
let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

" Rust
let g:rustfmt_autosave = 1
let g:ale_completion_enabled = 1
let g:ale_linters = {
\  'rust': ['analyzer'],
\}

autocmd BufNewFile,BufRead *.rs set filetype=rust
" End rust

""" Section: Packages {{{1

call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', { 'do': 'yarn install', 'branch': 'release' }
Plug 'neoclide/jsonc.vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'lucasecdb/vim-codedark'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
" Begin themes
" Plug 'kaicataldo/material.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'projekt0n/github-nvim-theme'
" Plug 'udalov/kotlin-vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
" End themes
Plug 'jparise/vim-graphql'
Plug 'chrisbra/vim-commentary'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" Rust
Plug 'rust-lang/rust.vim'

" Javascript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
Plug 'MaxMEllon/vim-jsx-pretty'

call plug#end()

""" }}}1
""" Section: Options {{{1

set langmenu=en_US
let $LANG='en_US'
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set incsearch
set nohlsearch
set foldmethod=indent
set foldopen+=jump
set foldlevel=99
set number relativenumber
set backspace=indent,eol,start
set clipboard=unnamedplus
set scrolloff=3
set splitbelow
set splitright
set cursorline
set mouse=a
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
" set completeopt+=noinsert
" Rust
" set completeopt+=menu,menuone,preview,noselect,noinsert
set completeopt+=menu,menuone,preview,noselect
" End rust
set nohls
set ignorecase
set updatetime=300

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

set laststatus=2

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

""" }}}1
""" Section: Mappings {{{1

let mapleader=','

inoremap jk <esc>

" Window switching
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l

" Buffer switching
nnoremap <silent> <s-l> :bnext<cr>
nnoremap <silent> <s-h> :bprevious<cr>

" Misc
nnoremap <silent> <leader>q :q<cr>
""" Section: CoC {{{2

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

hi CocSearch ctermfg=12 guifg=#18A3FF
hi CocMenuSel ctermbg=109 guibg=#13354A

nnoremap <silent> <leader>ee :CocCommand eslint.executeAutofix<cr>
nnoremap <silent> <leader>et :CocCommand tslint.fixAllProblems<cr>

"""}}}2

" Fugitive
nnoremap <silent> <leader>c :Git commit<cr>
nnoremap <silent> <leader>s :Git<cr>

nnoremap <leader>r :arg 
cnoremap <leader>r :arg 
nnoremap <leader>R :argdo 
cnoremap <leader>R :argdo 

command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, {'options': ['--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']})

" Fuzzy finder
nnoremap <leader>t :GFiles && git ls-files -o --exclude-standard<cr>

" Terminal
tnoremap jk <c-\><c-n>

" Formatters
vnoremap <leader>fg :!prettier --stdin --stdin-filepath query.gql<cr>
vnoremap <leader>fj :!prettier --stdin --stdin-filepath module.js<cr>
vnoremap <leader>ft :!fmt -80 -s<cr>

nnoremap <leader>p :Prettier<cr>

" Insert mode
inoremap jk <esc>

command! WQ wq
command! Wq wq
command! W w
command! Q q

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Deno
command DFmt :silent !deno fmt %

nnoremap <leader>df :DFmt<cr>

""" }}}1
""" Section: Plugins options {{{1

let g:airline_powerline_fonts=1
let g:airline_theme='bubblegum'
let g:airline_left_sep=''
let g:airline_right_sep=''

let g:ale_completion_enabled=1
let g:ale_virtualtext_cursor=1

let g:javascript_plugin_jsdoc = 1

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_virtualtext_cursor = 1
let g:ale_linters = {
\  'python': ['flake8'],
\  'typescript': ['eslint', 'tsserver', 'tslint'],
\  'javascript': ['eslint', 'flow', 'flow-language-server'],
\  'graphql': ['gqlint']
\}

let g:material_theme_style = 'dark'
let g:material_terminal_italics = 1

let g:tsuquyomi_single_quote_import=1
let g:tsuquyomi_shortest_import_path = 1
let g:tsuquyomi_use_vimproc=1
let g:tsuquyomi_disable_quickfix=1

"""}}}
""" Section: Functions {{{1

function! CheckTermAndDisableNumber()
  if &buftype ==# "terminal"
    setlocal nonumber norelativenumber
  endif
endfunc

"""}}}1
""" Section: Autocommands {{{1

if has('autocmd')
  filetype indent plugin on

  augroup FTOptions
    autocmd!
    autocmd FileType gitcommit setlocal spell
    autocmd FileType nginx setlocal indentexpr= |
          \ setlocal cindent |
          \ setlocal cinkeys-=0#
    autocmd FileType cs setlocal shiftwidth=4 |
          \ setlocal softtabstop=4
  augroup END
  augroup Coc
    autocmd!
    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')
  augroup END
  if has('nvim')
    augroup Term
      autocmd!
      autocmd TermOpen * :call CheckTermAndDisableNumber()
      autocmd WinLeave * :call CheckTermAndDisableNumber()
      autocmd WinEnter * :call CheckTermAndDisableNumber()
      autocmd BufEnter * :call CheckTermAndDisableNumber()
      autocmd BufLeave * :call CheckTermAndDisableNumber()
    augroup END
  endif
endif

"""}}}1
""" Section: Visual {{{1

" if has('syntax')
" if !has('syntax_on') && !exists('syntax_manual')
" syntax on
" endif

" if has('gui')
" set linespace=3
" set guioptions-=r
" set guioptions-=L
" endif

" set termguicolors
" let g:material_theme_style = 'ocean'
" colorscheme material
" let g:lightline = { 'colorscheme': 'material_vim' }
" endif

colorscheme github_dimmed
"""}}}1
