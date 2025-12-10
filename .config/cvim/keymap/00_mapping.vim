"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"             Content editing: Vim at the speed of thoughts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Faster Command mode access   {{{
" - eg: :w  becomes ;w
"   - effectively reducing stroke count from S-; w (5 strokes) to ;w (3 strokes)
if F_IsKeymapOn('n', '*', v:null) | nnoremap ; : | endif
"}}}

" Undo {{{
" Display undo tree
if F_IsKeymapOn('n', 'toggleUndoTree', v:null) | nnoremap <F5> :MundoToggle<CR> | endif
"}}}

" Scrolling{{{
" Scroll viewport faster
if F_IsKeymapOn('n', '*', v:null) | nnoremap <C-e> 3<C-e> | endif
if F_IsKeymapOn('n', '*', v:null) | nnoremap <C-y> 3<C-y> | endif
"}}}

" Tags{{{
if F_IsKeymapOn('n', '*', v:null) | map <F8> :TagbarToggle<CR> | endif
" }}}

" Content editing: Vim at the speed of thoughts {{{
" Force to master Vim's advanced motion and search functionnality 
" by disabling some/all arrow keys, hjkl keys, page up/down  and others
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardTimeOn()
" Mode switching alternative: Back to Normal Mode from Insert Mode
if F_IsKeymapOn('i', 'fast_switch_to_normal_mode', v:null) | :imap jj <Esc> | endif
" Search and replace selected text in VISUAL mode
if F_IsKeymapOn('n', '*', v:null) | vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left> | endif
"}}}

" Characters{{{
" Toggle `set list` (i.e hidden characters)
if F_IsKeymapOn('n', '*', v:null) | nmap <leader>l :set list!<CR> | endif
"}}}

" Saving files {{{
" Sudo a file after openning it
if F_IsKeymapOn('n', '*', v:null) | :cmap w!! w !sudo tee % >/dev/null | endif
"}}}

" Help{{{
" Show quick help
if F_IsKeymapOn('n', '*', v:null) | nnoremap <leader>hh :help quickref<CR> | endif
" }}}

" Window{{{
" Resize window
" - Keep it synced with tmux pane keybindings
if F_IsKeymapOn('n', '*', v:null) | map <C-l> 5<C-w>< | endif
if F_IsKeymapOn('n', '*', v:null) | map <C-h> 5<C-w>> | endif
if F_IsKeymapOn('n', '*', v:null) | map <C-j> 3<C-w>+ | endif
if F_IsKeymapOn('n', '*', v:null) | map <C-k> 3<C-w>- | endif
" Pane splittng 
" - Use default vim splitting keybindings:
"   - <leader> C-w v (vertical split)
"   - <leader> C-w s (horizontal split)
" - Keep it synced with tmux pane keybindings
" Deprecated pane split mapping. vim's default are perfect.
"  nnoremap <leader>- :split<enter>
"  nnoremap <leader>\| :vsplit<enter>
"}}}

" Which keybinds {{{
" NOTE: ',' is my <Leader>. Can't use literal '<Leader>' here
if F_IsKeymapOn('n', '*', v:null) | nnoremap <silent> <leader> :WhichKey ','<CR> | endif
"}}}


" *vimrc file development {{{
" Save current file then reload VIM distribution specific vim conf
" FIXME: Only vim + nvim
" FIXME: IDEAVim has special mapping
if F_IsKeymapOn('n', '*', v:null) | :nmap <leader>imrc <Esc>:w<CR>:source $MYVIMRC<CR>:echo $MYVIMRC .' reloaded'<CR> | endif
"}}}



" ----------------------------------

" Motions {{{
" - Move lines up/down
"
"   SUPER, CMD, WIN - these are all equivalent: on macOS the Command key.
"   ALT, OPT, META - these are all equivalent: 
"    - on macOS the Option key
"    - on other systems the Alt or Meta key.
"
" <A-j> -> ∆
"nnoremap ∆ :m .+1<CR>==
" <A-k> -> ˚
if F_IsKeymapOn('n', '*', v:null) | nnoremap ˚ :m .-2<CR>== | endif
" <A-j> <Esc> -> ∆ <Esc>
if F_IsKeymapOn('n', '*', v:null) | inoremap ∆ <Esc>:m .+1<CR>==gi | endif
" <A-k> <Esc> -> ˚ <Esc>
if F_IsKeymapOn('n', '*', v:null) | inoremap ˚ <Esc>:m .-2<CR>==gi | endif
" <A-j> -> ∆
if F_IsKeymapOn('n', '*', v:null) | vnoremap ∆ :m '>+1<CR>gv=gv | endif
" <A-k> -> ˚
if F_IsKeymapOn('n', '*', v:null) | vnoremap ˚ :m '<-2<CR>gv=gv | endif
"}}}

" Search {{{
" Cancel search highlight
if F_IsKeymapOn('n', '*', v:null) | :nmap <silent> <leader>/ :nohlsearch<CR> | endif
"}}}

" Switch to normal mode {{{
if F_IsKeymapOn('n', '*', v:null) | vmap i <Esc> | endif
if F_IsKeymapOn('n', '*', v:null) | imap jk <Esc> | endif
"}}}

" View mode {{{
" Fullscreen buffer (vertial only / no toggle)
if F_IsKeymapOn('n', '*', v:null) | map <Leader>vf <C-w>_ | endif
" }}}

" Tab
" - Tab switch
" gT - Previous tab (vim's builtin)
" gt - Next tab (vim's builtin)
" - Pin/unpin tab
" No support  
" - Close current/all/other/unpinned tabs
" Not enabled in IDEAVim

" Pane
" - Unsplit Pane
" map :q ...
" - Unsplit all panes
" map <C-W> <C-O> ...

" Comment
" - Comment by line
" map ,cc ...

" Terminal
" - Display terminal
" map ,t :term ...
" - open terminal in current dir (experimental)
if F_IsKeymapOn('n', '*', v:null) | map <Leader>tc :term ~/.bin/vim-term-cwd.sh "%:h";   | endif

" Todo/Fixme
" - Show todo/fixme
if F_IsKeymapOn('n', '*', v:null) | map <Leader>td :Ag TODO\|FIXME | endif
