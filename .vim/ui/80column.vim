" Show 80th column (Vim 7.3+ only) 
" Show 80th column (Vim 7.3+ only) Show 80th column (Vim 7.3+ only) Show 80th column (Vim 7.3+ only) Show 80th column (Vim 7.3+ only)
" option 1: highligh pieces of text over the limit
"  - https://www.youtube.com/watch?v=aHm36-na4-4
" option 0: static column
"  - http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns"

function! F_Enable80thColumnMark(mode)
    if a:mode == 1 || a:mode == 0
        call F_Show80thColumnMark(a:mode)
        let g:column_80th_mark_mode = a:mode
    endif
endfunction

function! F_Disable80thColumnMark()
    call F_Hide80thColumnMark(g:column_80th_mark_mode)
endfunction

function! F_Show80thColumnMark(mode)
    if v:version <= 703
        return
    endif

    if a:mode == 0
        " Enable option 0
        setlocal colorcolumn=80
    endif
    if a:mode == 1
        augroup vimrc_autocmds
            autocmd!
            autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#111111
            autocmd BufEnter * match OverLength /\%80v.*/
        augroup END
        doautocmd vimrc_autocmds BufEnter
    endif    
endfunction

function! F_Hide80thColumnMark(mode)
    if v:version <= 703
        return
    endif

    if a:mode == 0
        " Remove static column
        setlocal colorcolumn=
    endif
    if a:mode == 1
        if exists("#vimrc_autocmds")
            echo "0:1"
            highlight clear OverLength
            match none
            autocmd! vimrc_autocmds
            augroup! vimrc_autocmds
        endif 
    endif
endfunction

let g:column_80th_mark_mode = 1
call F_Enable80thColumnMark(g:column_80th_mark_mode)
