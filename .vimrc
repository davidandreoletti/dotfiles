"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       David Andreoletti
"       http://davidandreoletti.com
"
" Sections:
"    -> Vundle
"    -> Bundles
"    -> General
"    -> VIM UI
"    -> Colors and Fonts
"    -> Syntax
"    -> Backup/Swap
"    -> File tree
"    -> Completion
"    -> Mapping
"    -> Tabs and indents 
"    -> Visual mode
"    -> Normal mode
"    -> Motions
"    -> Status line
"    -> Search
"    -> Spell checking
"    -> Misc
"    -> Mouse
"    -> Helper functions
"    -> Help
"    -> File type
"    -> Hidden characters
"    -> Match pairs
"    -> Scrolling
"    -> Performance
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

source $HOME/.vim/perso/vim/vimrc-functions.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vundle
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Bundles
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Doxygen
Bundle 'vim-scripts/DoxygenToolkit.vim'

" UltiSnips (Snippets)
Bundle 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories=["UltiSnips", "perso/snippets"]

" Master Vim's advanced motion and search
Bundle 'wikitopian/hardmode'

" Color schemes
Bundle 'flazz/vim-colorschemes'

" File Explorer
Bundle 'scrooloose/nerdtree'

" Commenting
Bundle 'scrooloose/nerdcommenter'

" Syntastic
" C++/C/X*ML/JSON .. syntax checking plugin
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

" Convenient way to quickly reach buffers/files/commands/bookmarks/tags
Bundle 'L9'
Bundle 'FuzzyFinder'

" Class outliner
if vundleInstallRequired
   call F_Tagbar_InstallDependencies()
endif
Bundle 'majutsushi/tagbar'

" Powerline - Better status bar
if vundleInstallRequired
   call F_PowerLine_InstallDependencies()
endif
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Bundle 'Lokaltog/vim-powerline'
set t_Co=256
"let g:Powerline_symbols='unicode'
let g:Powerline_symbols='fancy'
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

" Installing bunldes the first time
if vundleInstallRequired
   call F_Vundle_InstallBundles()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=1000

" As many undo as history
set undolevels=1000

" Line numbers
set nu

"remap leaderkey to ,
:let mapleader = ","

" Hides buffer instead of closing them
" Consequence: you can have unwritten changes to a file and open
" a new file " using :e, without being forced to write or undo 
" your changes first. Also, undo buffers and marks are preserved 
" while the buffer is open.
set hidden

" No lines wrapped
set nowrap

" Show 80th column (Vim 7.3+ only)
" http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
set colorcolumn=80
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM UI
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color scheme
" Preview of available color schemes for Java/C/Latex: https://code.google.com/p/vimcolorschemetest/
colorscheme torte

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntax
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on that syntax highlighting
syntax on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Backup/Swap 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Move swap files and backup to central location
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open a NERDTree automatically when vim starts up if no files 
" were specified 
autocmd vimenter * if !argc() | NERDTree | endif
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make file/command completion useful
set wildmenu
set wildmode=list:longest

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F2> :NERDTreeToggle<CR>
map <F8> :TagbarToggle<CR>
" Disable (temporary) all auto indenting/expansion
set pastetoggle=<F3>

" Force to master Vim's advanced motion and search functionnality 
" by disabling arrow keys, hjkl keys, page up/down  and others
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
nnoremap <leader>h <Esc>:call EasyMode()<CR>
nnoremap <leader>H <Esc>:call HardMode()<CR>

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tabs and indents
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Normal mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Intuitive backspacing
set backspace=indent,eol,start

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Motion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mouse
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable mouse support for all modes
set mouse=a

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Help
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load custom helps file (such as  my cheatsheet)
:helptags ~/.vim/doc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File type
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Hidden characters 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,trail:·,eol:¬

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Match pair
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extends standard vim % to apply to:
" - whole words: "if" and "endif"
" - group of more than 2 words : "if", "else", "endif"
runtime macros/matchit.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File type
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File type
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File type
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Scrolling
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Minimal number of screen lines to keep above and below cursor
" (vertical scrolling only)
set scrolloff=3

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Performance 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't update the display while executing macros
set lazyredraw
