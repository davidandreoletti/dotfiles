" Edit crontab file in place {{{
" src: https://vim.fandom.com/wiki/Editing_crontab
autocmd filetype crontab setlocal nobackup nowritebackup
"" on macOS
au BufEnter /tmp/crontab.* setl backupcopy=yes
"" on macOS
au BufEnter /private/tmp/crontab.* setl backupcopy=yes
"}}}
