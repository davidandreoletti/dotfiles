" Colors and Fonts{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" How to advertize terminal color properly ?
" - term vs t_Co:
" -- http://stackoverflow.com/questions/15375992/vim-difference-between-t-co-256-and-term-xterm-256color-in-conjunction-with-tmu
" - tmux, COLORTERM, TERM
" -- http://stackoverflow.com/questions/20557666/vim-256-colour-strange-behaviour-with-tmux?rq=1
" 
" Conclusion: Settings below are not needed in vimrc if the terminal/terminal 
"             multiplexer is advertising 256 colors properly
"set term=xterm-256color
"set t_Co=256

" Color scheme
" Preview of available color schemes for Java/C/Latex: https://code.google.com/p/vimcolorschemetest/
colorscheme torte
"}}}
