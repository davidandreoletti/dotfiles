"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       David Andreoletti
"       http://davidandreoletti.com
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"}}}
" Load VIM functions {{{
source $HOME/.vim/common/functions.vim
" Detect what vim variant is being used {{{
let g:vimFlavor = F_Get_Vim_Flavor()
"}}}
" Vundle{{{
" Setup: https://github.com/gmarik/vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Forget being compatible with good ol' vi
" - required by Vundle
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

" Managed bundles{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Doxygen
Bundle 'vim-scripts/DoxygenToolkit.vim'
" Snippets Engine
Bundle 'SirVer/ultisnips'
" Predefined snippets 
" - UltiSnips's snippets are separated from the engine.
Plugin 'honza/vim-snippets'
" Master Vim's advanced motion and search
Bundle 'takac/vim-hardtime'
" Ease motions
Bundle 'Lokaltog/vim-easymotion'
" Operations on surroundings
" parentheses, brackets, quotes, XML tags, and more
Bundle 'tpope/vim-surround'
" Visualize Vim Undo Tree
if g:vimFlavor ==# g:VIM_FLAVOR_VIM
    " vim + neovim support, without newer updates
    Bundle 'sjl/gundo.vim'
elseif g:vimFlavor ==# g:VIM_FLAVOR_NEOVIM
    " vim + neovim support, with newer updates (gundo.vim fork),
    Bundle 'simnalamburt/vim-mundo'     
endif
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
" TabNine (ML based auto completion, much better)
Bundle 'zxqfl/tabnine-vim'
" NeoMake
Bundle 'neomake/neomake'
" Fast way to reach/search:
" - buffers (: Buffers)
" - files (: Files)
" - commands
" - bookmarks
" - tags 
" - lines
" - projects
" - help
" - pages
" - commands
" - history
" - git commits
" - etc 
" See details at https://github.com/junegunn/fzf.vim#commands
" - fzf replaces Ctrl-P, FuzzyFinder and Command-T)
" - fzf is really fast compared to Crtl-P' vimL fuzy finder implementation
set rtp +=/usr/local/opt/fzf
Bundle 'junegunn/fzf.vim'
" Show a VCS diff using Vim's sign column. 
Bundle 'mhinz/vim-signify'
" Class outliner
if vundleInstallRequired
   call F_Tagbar_InstallDependencies()
endif
Bundle 'majutsushi/tagbar'
" Lightweight status bar
Bundle 'bling/vim-airline'
" Org-mod for vim
Bundle 'jceb/vim-orgmode'
" Dependencies for org-mode
Bundle 'tpope/vim-speeddating'
" Display vertical thin lines at each indentation level for code
" indented with spaces
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

" Install bundles (on very first vim use) 
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

"}}}
" VIM UI{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Better status bar
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs

" Show matching brackets when text indicator is over them
set showmatch

" How many 10th of a second to blink when matching brackets
set mat=2

" Set to auto read when a file is changed from the outside
set autoread

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

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
" Turn on syntax highlighting
syntax on
"}}}
" Backup/Swap/Undo{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backups
" Move backup files to a central location
set backupdir=~/.vim/tmp/backup,/tmp/

" Undo
" Move undo files to a central location
set undodir=~/.vim/tmp/undo,/tmp/
set undofile

" Swap
" Move swap to a central location
set directory=~/.vim/tmp/swap,/tmp/
"}}}
" Completion{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make file/command completion useful
set wildmenu
set wildmode=list:longest
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
" File typc{{{
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
" FIXME: is this a plugin ?
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
set scrolloff=6
"}}}
" Performance{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't update the display while executing macros
set lazyredraw
"}}}
" Plugins settings{{{
call F_Load_PluginsSettings('$HOME/.vim/settings')
"}}}
" Commands {{{
call F_Load_Commands('$HOME/.vim/commands')
"}}}
" Key Mappings{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call F_Load_KeyMappings('$HOME/.vim/keymap')
"}}}
" UI Enhancements {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call F_Load_UISettings('$HOME/.vim/ui')
"}}}"
" Local vimrc{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call F_Load_LocalVimrc('$HOME/.vimrc.local')
"}}}
" Help{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load custom helps file 
" - personal cheatsheets
:helptags ~/.vim/doc
"}}}"
