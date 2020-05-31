set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
set nu

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'connorholyday/vim-snazzy'
Plugin 'itchyny/lightline.vim'
Plugin 'ap/vim-css-color'
Plugin 'mhinz/vim-startify'
Plugin 'tpope/vim-fugitive'
Plugin 'rhysd/vim-clang-format'
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'
set laststatus=2
if !has('gui_running')
  set t_Co=256
endif
call vundle#end()            " required
    filetype plugin indent on    " required
let g:lightline = {
      \ 'colorscheme': 'one',
      \ }
