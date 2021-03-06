syntax on
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set noswapfile
set undofile
set backupdir=~/.vim/backup/
set incsearch
set nu
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')


" let Vundle manage Vundle, required
" Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'connorholyday/vim-snazzy'
Plugin 'itchyny/lightline.vim'
Plugin 'ap/vim-css-color'
Plugin 'mhinz/vim-startify'
Plugin 'tpope/vim-fugitive'
Plugin 'rhysd/vim-clang-format'
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'
Plugin 'scrooloose/syntastic'
Plugin 'plasticboy/vim-markdown'
Plugin 'elzr/vim-json'
Plugin 'valloric/youcompleteme'
Plugin 'raimondi/delimitmate'
Plugin 'sheerun/vim-polyglot'

" Custom Settings
set laststatus=2
if !has('gui_running')
  set t_Co=256
endif
call vundle#end()            " required
    filetype plugin indent on    " required
let g:lightline = {
      \ 'colorscheme': 'snazzy',
      \ }
colorscheme snazzy
