call plug#begin()
Plug 'preservim/nerdtree'
Plug 'vim-python/python-syntax'
Plug 'vim-scripts/javacomplete'
Plug 'pprovost/vim-ps1'
Plug 'othree/xml.vim'
Plug 'rust-lang/rust.vim'
call plug#end()
set number
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
			\ execute 'NERDTree' argv()[0] | endif
:set shiftwidth=2
:set autoindent
:set smartindent
:set tabstop=2
