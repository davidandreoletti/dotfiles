" Function Keys {{{
nnoremap <F5> :MundoToggle<CR>

map <F8> :TagbarToggle<CR>
" Disable (temporary) all auto indenting/expansion
set pastetoggle=<F3>
"}}}

" Content editing: Vim at the speed of thoughts {{{

" Force to master Vim's advanced motion and search functionnality 
" by disabling some/all arrow keys, hjkl keys, page up/down  and others
"autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardTimeOn()

" Disable PageUp/PageDown and arrow keys 
noremap <buffer> <Left> <Nop>
noremap <buffer> <Right> <Nop>
noremap <buffer> <Up> <Nop>
noremap <buffer> <Down> <Nop>
noremap <buffer> <PageUp> <Nop>
noremap <buffer> <PageDown> <Nop>

" Get efficient with most vim commands
" Eg: :w  becomes ;w
" Effectively reducing stroke count from S-; w (5 strokes) to ;w (3 strokes) 
nnoremap ; :

" Mode switching alternative: Back to Normal Mode from Insert Mode
:imap jj <Esc>

" Search and replace selected text in VISUAL mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
"}}}

" Characters{{{
" Toggle `set list` (i.e hidden characters)
nmap <leader>l :set list!<CR>
"}}}

" VIM files Development {{{
" Make it easy to save current .vimrc as well as to $VIMRC and reload vim conf
:nmap <leader>rv <Esc>:w! .vimrc<CR>:saveas! $MYVIMRC<CR>:bd ~/.vimrc<CR>:e .vimrc<CR>:so $MYVIMRC<CR>:echo '$VIMRC reloaded'<CR>
"}}}

" Search {{{
" Clear hightlighted searches
:nmap <silent> ,/ :nohlsearch<CR>

" Find files with PATTERN in it
"nnoremap <leader>\ :FindFilesContainingPattern<SPACE>
"}}}

" Saving files {{{
" Sudo a file after openning it
:cmap w!! w !sudo tee % >/dev/null
"}}}

" Scrolling{{{
" Scroll viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
"}}}

" Help{{{
" Show quick help
nnoremap <leader>hh :help quickref<CR>
" }}}

" Window{{{
" Resize window
" - Keep it synced with tmux pane keybindings
map <C-l> 5<C-w><
map <C-h> 5<C-w>>
map <C-j> 3<C-w>+
map <C-k> 3<C-w>-
" Pane splittng 
" - Use default vim splitting keybindings:
"   - <leader> C-w v (vertical split)
"   - <leader> C-w s (horizontal split)
" - Keep it synced with tmux pane keybindings
" Deprecated pane split mapping. vim's default are perfect.
"  nnoremap <leader>- :split<enter>
"  nnoremap <leader>\| :vsplit<enter>
"}}}

