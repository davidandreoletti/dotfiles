" Hide 80 column mark on fzf windows
augroup hide_80th_column_mark_on_fzf
    autocmd!
    autocmd FileType fzf call F_Hide80thColumnMark(g:column_80th_mark_mode) 
    \| autocmd BufLeave <buffer> call F_Show80thColumnMark(g:column_80th_mark_mode)
augroup END

" Hide / Show statusline
" - hide when fzf buffer is displayed
" - show when fzf buffer is hidden 
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
