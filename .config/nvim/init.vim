set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Enable 24bit true color
" src: https://www.integralist.co.uk/posts/vim-themes/
if (has("termguicolors"))
 set termguicolors
endif

source ~/.vim/vimrc
