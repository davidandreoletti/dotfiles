" Hide / Show statusline
" - hide when fzf buffer is displayed
" - show when fzf buffer is hidden 
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
