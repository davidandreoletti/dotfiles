" Function Keys {{{
if g:vimFlavor ==# g:VIM_FLAVOR_VIM
    nnoremap <F5> :GundoToggle<CR>
elseif g:vimFlavor ==# g:VIM_FLAVOR_NEOVIM
    nnoremap <F5> :MundoToggle<CR>
endif

map <F8> :TagbarToggle<CR>
" Disable (temporary) all auto indenting/expansion
set pastetoggle=<F3>
"}}}

" Force to master Vim's advanced motion and search functionnality 
" by disabling some/all arrow keys, hjkl keys, page up/down  and others
"autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardTimeOn()

" Get efficient with most vim commands
" Eg: :w  becomes ;w
" Effectively reducing stroke count from S-; w (5 strokes) to ;w (3 strokes) 
nnoremap ; :

" Back to Normal Mode from Insert Mode
:imap jj <Esc>
" Make it easy to save current .vimrc as well as to $VIMRC and reload vim conf
:nmap <leader>rv <Esc>:w! .vimrc<CR>:saveas! $MYVIMRC<CR>:bd ~/.vimrc<CR>:e .vimrc<CR>:so $MYVIMRC<CR>:echo '$VIMRC reloaded'<CR>
" Clear hightlighted searches
:nmap <silent> ,/ :nohlsearch<CR>
" Sudo a file after openning it
:cmap w!! w !sudo tee % >/dev/null
" Toggle `set list` (i.e hidden characters)
nmap <leader>l :set list!<CR>

" Scroll viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Show quick help
nnoremap <leader>hh :help quickref<CR>

" Resize window
map <C-l> 5<C-w>>
map <C-h> 5<C-w><
map <C-j> 3<C-w>+
map <C-k> 3<C-w>-

" Search and replace selected text in VISUAL mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" Disable PageUp/PageDown and arrow keys 
noremap <buffer> <Left> <Nop>
noremap <buffer> <Right> <Nop>
noremap <buffer> <Up> <Nop>
noremap <buffer> <Down> <Nop>
noremap <buffer> <PageUp> <Nop>
noremap <buffer> <PageDown> <Nop>

" Find files with PATTERN in it
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
nnoremap \ :Find<SPACE>


