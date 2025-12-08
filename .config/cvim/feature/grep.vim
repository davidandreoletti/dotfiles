" Replace vim-grep (slow) by a very fast grep
" --vimgrep   : vim's native grep compatible output
" --smart-case: lowercase search is case insensitive
"               upcase search is case sensitive
" --uu        : seach in all text files, including ignored ones
set grepprg=rg\ --vimgrep\ --smart-case\ -uu
