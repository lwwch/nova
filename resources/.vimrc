set number
set nobackup
set noswapfile
set t_Co=256
set mouse=incr
set hlsearch
set autoindent
set smartindent

syntax on

set smarttab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

autocmd FileType make setlocal noexpandtab

set ruler
set showcmd

colorscheme 256-grayvim

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif
  set runtimepath+=/home/myles/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('/home/myles/.vim/bundle'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'bling/vim-airline'

call neobundle#end()

NeoBundleCheck

map <C-t> :NERDTreeToggle<CR>
filetype plugin indent on
