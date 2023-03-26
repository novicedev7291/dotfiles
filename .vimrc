" Off Vi-compatible mode
set nocompatible

" Set relative line numbers
set relativenumber

" Set backspace key to work normally in insert mode after updating vim
set backspace=indent,eol,start

" Enable comments in jsonc files
autocmd FileType json syntax match Comment +\/\/.\+$+

" Load all plugins
source ~/.vim/plugged.vim

" Load  keybindings
source ~/.vim/keys.vim
