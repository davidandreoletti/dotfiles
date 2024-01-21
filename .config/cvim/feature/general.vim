" General{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" As many undo as history
set undolevels=1000

" Absolute Line numbers
set number 
" Relative Line numbers
set relativenumber
" Show keystrokes
set showcmd
" Hide Vim startup message
set shortmess+=I

" neovim integrations
if g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
    " Python
    let g:python3_host_prog = $_NEOVIM_PYENV_PYTHON_PATH . "/bin/python"
    " NodeJS
    if executable('volta')
        let g:node_host_prog = trim(system("volta which neovim-node-host"))
    endif
endif

" Hides buffer instead of closing them
" Consequence: you can have unwritten changes to a file and open
" a new file " using :e, without being forced to write or undo 
" your changes first. Also, undo buffers and marks are preserved 
" while the buffer is open.
set hidden

" No lines wrapped
set nowrap
"}}}

