" Replace vim-grep (slow) by a very fast grep
" --vimgrep   : vim's native grep compatible output
" --smart-case: lowercase search is case insensitive
"               upcase search is case sensitive
" --uu        : seach in all text files, including ignored ones
set grepprg=rg\ --vimgrep\ --smart-case\ -uu

" Load ability to filter quickfix search result with :Cfilter FOO/bar
packadd! cfilter

" src: https://blog.beezwax.net/advanced-search-and-replace-with-vim/
function! s:QfRemoveAtCursor() abort
  let currline = line('.')
  let items = getqflist()->filter({ index -> (index + 1) != currline })
  call setqflist(items, 'r')
  execute 'normal ' . currline . 'G'
endfunction

augroup quickfix
  autocmd!
  autocmd FileType qf nnoremap &lt;buffer>&lt;silent> x :call &lt;SID>QfRemoveAtCursor()&lt;CR>
augroup END
