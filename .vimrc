"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       David Andreoletti
"       http://davidandreoletti.com
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom VIM functions {{{
source $HOME/.vim/perso/vim/vimrc-functions.vim
"}}}
" Vundle{{{
" Setup: https://github.com/gmarik/vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Forget being compatible with good ol' vi
set nocompatible

let vundleInstallRequired = F_Vundle_IsVundleInstalled()
if vundleInstallRequired
    call F_Vundle_InstallVundle()
endif

" required for vundle
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle required! 
Bundle 'gmarik/vundle'
"}}}
" Bundles{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Doxygen
Bundle 'vim-scripts/DoxygenToolkit.vim'

" UltiSnips (Snippets)
Bundle 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories=["UltiSnips", "perso/snippets"]

" Master Vim's advanced motion and search
Bundle 'takac/vim-hardtime'
let g:list_of_normal_keys = [ "h", "j", "k", "l", "-", "+" ]
let g:list_of_visual_keys = [ "h", "j", "k", "l", "-", "+" ]
let g:hardtime_maxcount = 1
let g:hardtime_allow_different_key = 1
let g:hardtime_timeout = 1000

" Ease motions
Bundle 'Lokaltog/vim-easymotion'

" Operations on surroundings
" parentheses, brackets, quotes, XML tags, and more
Bundle 'tpope/vim-surround'

" Visualize Vim Undo Tree
Bundle 'sjl/gundo.vim'

" Color schemes
Bundle 'flazz/vim-colorschemes'

" Make gvim-only colorscheme work transparently in vim terminal
Bundle 'vim-scripts/CSApprox'

" Commenting
Bundle 'scrooloose/nerdcommenter'

" Align things
Bundle 'godlygeek/tabular'

" Syntastic
" C++/C/X*ML/JSON/Javascript .. syntax checking plugin
Bundle "scrooloose/syntastic"
" Setup syntastic's status line
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
" Syntastic Error Window will be opened automatically when errors are
" detected and closed automatically when none are detected
let g:syntastic_auto_loc_list=1
" Syntastic show syntaxhighlighting to mark error (where possible)
let g:syntastic_enable_highlighting=1
" Syntastic custom error symbols according to error type
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
" C++ setup: https://github.com/scrooloose/syntastic/wiki/C--%3A---gcc
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_no_default_include_dirs = 1
let g:syntastic_cpp_auto_refresh_includes = 1
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_compiler = 'clang++'
" Javascript
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'  " Use project's eslint binary
let g:syntastic_javascript_eslint_args = ['--fix'] " --fix to fix warning/errors automatically
" Reload js file fixed with eslint --fix
" src: https://vi.stackexchange.com/a/11281
set autoread
" HTML5
let g:syntastic_html_tidy_exec = 'tidy5'

au VimEnter *.js au BufWritePost *.js checktime

if vundleInstallRequired
   call F_npm_InstallIfMissing()
   call F_jshint_InstallifMissing()
endif

" Convenient way to quickly reach buffers/files/commands/bookmarks/tags
Bundle 'ctrlpvim/ctrlp.vim'
" Default seach mode
let g:ctrlp_cmd = 'CtrlPMixed'
" Local working directory
let g:ctrlp_working_path_mode = 'rwa'
" Position/Listing order/Reslt Window height
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:15'
" Jump to openned file (in window) if already openned
let g:ctrlp_switch_buffer = 'Et'
" Enable Per session caching
let g:ctrlp_use_caching = 1
" Enabled Cross session cahcing
let g:ctrlp_clear_cache_on_exit = 1
" Show hidden files
let g:ctrlp_show_hidden = 1
" Ignore custom files/dirs
let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll)$',
            \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
            \ }
" Number max of files to scan
let g:ctrlp_max_files = 0
" Max number of MRU files
let g:ctrlp_mruf_max = 1000
" Show MRU files only relative to current dir
let g:ctrlp_mruf_relative = 1
" Save MRU list on vim exiting only
let g:ctrlp_mruf_save_on_update = 1
" Enable CTRL-P extensions
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
            \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']

" Show a VCS diff using Vim's sign column. 
Bundle 'mhinz/vim-signify'

" Class outliner
if vundleInstallRequired
   call F_Tagbar_InstallDependencies()
endif
Bundle 'majutsushi/tagbar'

" Better status bar
"if vundleInstallRequired
   "call F_PowerLine_InstallDependencies()
"endif
"Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Bundle 'Lokaltog/vim-powerline'
"let g:Powerline_symbols='unicode'
"let g:Powerline_symbols='fancy'

set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

Bundle 'bling/vim-airline'
" Add powerline symbols to vim-airline
"let g:airline_powerline_fonts = 1

" Org-mod for vim
Bundle 'jceb/vim-orgmode'
" Dependencies for org-mode
Bundle 'tpope/vim-speeddating'

" Display vertical thin lines at each indentation level for code indented with
" spaces
Bundle 'Yggdroot/indentLine'

" Diff swap and content file
Bundle 'chrisbra/Recover.vim'

" Sublime Text's muliple selection
Bundle 'terryma/vim-multiple-cursors'

" Rename a buffer within Vim and on the disk
Bundle 'danro/rename.vim'

" Support for JSON syntax highlighting
Bundle 'leshill/vim-json'

" Git wrapper
Bundle 'tpope/vim-fugitive'

" Zoom in/out window
Bundle 'vim-scripts/ZoomWin'

" Support for Objective-C/Cocoa dev
Bundle 'msanders/cocoa.vim'

" Character encoding value
" (improves over :ga)
Bundle 'tpope/vim-characterize'

" Show vim's marks
Bundle 'kshenoy/vim-signature'

" Enhanced Javascript syntax with support for ES6
" (based on 'jelera/vim-javascript-syntax')
Bundle 'othree/yajs.vim'


" Installing bunldes the first time
if vundleInstallRequired
   call F_Vundle_InstallBundles()
endif
"}}}
" General{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=1000

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

" Map *leaderkeys
:let mapleader = ","
:let maploacalleader = "\\"

" Hides buffer instead of closing them
" Consequence: you can have unwritten changes to a file and open
" a new file " using :e, without being forced to write or undo 
" your changes first. Also, undo buffers and marks are preserved 
" while the buffer is open.
set hidden

" No lines wrapped
set nowrap

" Show 80th column (Vim 7.3+ only)
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
"}}}
" VIM UI{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show matching brackets when text indicator is over them
set showmatch

" How many 10th of a second to blink when matching brackets
set mat=2

" Set to auto read when a file is changed from the outside
set autoread

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" Change terminal's title
set title
set titlestring=VIM:\ %-25.55F\ %a%r%m titlelen=70
"}}}
" Colors and Fonts{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" How to advertize terminal color properly ?
" - term vs t_Co:
" -- http://stackoverflow.com/questions/15375992/vim-difference-between-t-co-256-and-term-xterm-256color-in-conjunction-with-tmu
" - tmux, COLORTERM, TERM
" -- http://stackoverflow.com/questions/20557666/vim-256-colour-strange-behaviour-with-tmux?rq=1
" 
" Conclusion: Settings below are not needed in vimrc if the terminal/terminal 
"             multiplexer is advertising 256 colors properly
"set term=xterm-256color
"set t_Co=256

" Color scheme
" Preview of available color schemes for Java/C/Latex: https://code.google.com/p/vimcolorschemetest/
colorscheme torte
"}}}
" Syntax{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on that syntax highlighting
syntax on
"}}}
" Backup/Swap{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Move swap files and backup to central location
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

"}}}
" Completion{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make file/command completion useful
set wildmenu
set wildmode=list:longest
"}}}
" Mapping{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F8> :TagbarToggle<CR>
nnoremap <F5> :GundoToggle<CR>

" Disable (temporary) all auto indenting/expansion
set pastetoggle=<F3>

" Force to master Vim's advanced motion and search functionnality 
" by disabling some/all arrow keys, hjkl keys, page up/down  and others
" autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardTimeOn()

" Get efficient with most vim commands
" Eg: :w    becomes ;w
"     Effectively reducing stroke count from S-; w (5 strokes) 
"     to ;w (3 strokes) 
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
"}}}
" Tabs and indents{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab is now 4 spaces (unless filetype specific)
set tabstop=4

" Copy indent from current line when creating a new line
set autoindent

" Copy structure of existing lines indent when autoindenting 
" a new line 
set copyindent

" Number of spaces to use for each step of (auto)indent
set shiftwidth=4

" Round to indent to multiple of shiftwidth
set shiftround

" Insert tab on start of line according to shiftwidth only
set smarttab

" Expand tabs into spaces
set expandtab
"}}}
" Normal mode{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Intuitive backspacing
set backspace=indent,eol,start
"}}}
" Search{{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Hightlight search results
set hlsearch

" Google-Instant like search results
set incsearch

" Ignore case while searching
set ignorecase

" Ignore case if search pattern is all lowercase, case-sensitive 
" otherwise
set smartcase
"}}}
" Mouse{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable mouse support for all modes
set mouse=a
"}}}
" Help{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load custom helps file (such as  my cheatsheet)
:helptags ~/.vim/doc
"}}}
" File type{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Unix as the standard file type
set ffs=unix,mac,dos

" Enables :
" - filetype detection 
" - plugin files for a specific file type  
" - loading indent file for a specific file type
" Required by: NERDCommenter
filetype plugin indent on

" Set doxygen tags according to filetype
autocmd FileType cpp,c,h,hpp,m,mm call F_DoxygenToolKit_SetCPPOrCTags()
autocmd FileType java call F_DoxygenToolKit_SetJAVATags()

" Edit crontab file in place
autocmd filetype crontab setlocal nobackup nowritebackup
"}}}
" Hidden characters{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,trail:·,eol:¬
"}}}
" Match pair{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extends standard vim % to apply to:
" - whole words: "if" and "endif"
" - group of more than 2 words : "if", "else", "endif"
runtime macros/matchit.vim
"}}}
" Encryption{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use blowfish by default
if has("cryptv")
    set cryptmethod=blowfish
endif
"}}}
" Scrolling{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Minimal number of screen lines to keep above and below cursor
" (vertical scrolling only)
set scrolloff=3
"}}}
" Performance{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't update the display while executing macros
set lazyredraw
"}}}
" Undo{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gundo_width = 60
let g:gundo_preview_height = 15
let g:gundo_preview_bottom = 1
"}}}
" Local vimrc{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(".vimrc.local")
   source .vimrc.local
endif
"}}}
