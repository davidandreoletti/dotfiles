" Show 80th column (Vim 7.3+ only)
if v:version > 703
    let g:toggle_80th_column_mark = 1 
    function! F_Toggle80thColumnMark()
        " option 1: highligh pieces of text over the limit
        "  - https://www.youtube.com/watch?v=aHm36-na4-4
        " option 0: static column
        "  - http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
        if g:toggle_80th_column_mark == 1
            " Disable option 0
            set colorcolumn=
            " Enable option 1
            augroup vimrc_autocmds
                autocmd!
                autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#111111
                autocmd BufEnter * match OverLength /\%80v.*/
            augroup END
            doautocmd vimrc_autocmds BufEnter
            let g:toggle_80th_column_mark = 0
        else
            " Disable option 1
            if exists("#vimrc_autocmds")
                echo "0:1"
                highlight clear OverLength
                match none
                autocmd! vimrc_autocmds
                augroup! vimrc_autocmds
            endif
            " Enable option 0
            set colorcolumn=80
            let g:toggle_80th_column_mark = 1
        endif
    endfunction
    call F_Toggle80thColumnMark()
endif
