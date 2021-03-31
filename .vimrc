call plug#begin()
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim'
call plug#end()

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" remove clipboard
set clipboard+=unnamedplus

" set syntax highlight on
syntax on

" Show line number
set number

" Tabs 2 spaces
set sts=2
set ts=2
set sw=2
