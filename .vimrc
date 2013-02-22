"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: 
"       David Andreoletti
"       http://davidandreoletti.com
"
" Sections:
"    -> Vundle
"    -> Bundles
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Syntax
"    -> Files and backups
"    -> File tree
"    -->Completion
"    -> Mapping
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> vimgrep searching and cope displaying
"    -> Search
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"    -> Help
"    -> File type
"    -> Performance
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

source .vim/vimrc-functions.vim

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
" Master Vim's advanced motion and search
Bundle 'wikitopian/hardmode'

" Color schemes
Bundle 'flazz/vim-colorschemes'

" File Explorer
Bundle 'scrooloose/nerdtree'

" Commenting
Bundle 'scrooloose/nerdcommenter'
filetype plugin on

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

" Line numbers
set nu

"remap leaderkey to ,
:let mapleader = ","
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
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
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open a NERDTree automatically when vim starts up if no files were specified 
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

" Force to master Vim's advanced motion and search functionnality by disabling arrow keys, hjkl keys, page up/down  and others
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
nnoremap <leader>h <Esc>:call EasyMode()<CR>
nnoremap <leader>H <Esc>:call HardMode()<CR>

:imap jj <Esc>
" Make it easy to save current .vimrc as well as to $VIMRC and reload vim conf
:nmap <leader>rv <Esc>:w! .vimrc<CR>:saveas! $MYVIMRC<CR>:so $MYVIMRC<CR>:e .vimrc<CR>:echo '$VIMRC reloaded'<CR>
" Clear hightlighted searches
:nmap <silent> ,/ :nohlsearch<CR>
" Sudo a file after openning it
:cmap w!! w !sudo tee % >/dev/null



" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, folding, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Hightlight search results
set hlsearch

" Google-Instant like search results
set incsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Performance 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't update the display while executing macros
set lazyredraw
