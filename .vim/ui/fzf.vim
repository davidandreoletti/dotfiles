" Hide 80 column mark on fzf windows
augroup hide_80th_column_mark_on_fzf
    autocmd!
    autocmd FileType fzf call F_Hide80thColumnMark(g:column_80th_mark_mode) 
    \| autocmd BufLeave <buffer> call F_Show80thColumnMark(g:column_80th_mark_mode)
augroup END
