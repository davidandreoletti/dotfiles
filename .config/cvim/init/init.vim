" Vim flavor detection {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Detect vim flavor
let g:vimFlavor = F_Get_Vim_Flavor()
let g:vimFlavorRootDir = F_Get_Vim_Flavor_Root_Dir() 
"}}}

" No vi support {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
"}}}

" Package Manager{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install/load package manager
if g:vimFlavor ==# g:VIM_FLAVOR_VIM
    let pluginManagerInstallationRequired = F_VimPlug_IsInstalled()
    if pluginManagerInstallationRequired
        call F_VimPlug_Install()
    endif

    call plug#begin(vimFlavorRootDir.'/bundle')
elseif g:vimFlavor ==# g:VIM_FLAVOR_NEOVIM
    " Bootstrap lazyvim
lua << EOF
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
EOF
endif

" Managed plugins{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 'CVIM Plugin'
"
" - name             : plugin name
" - lazy             : 1 => true
"                    : 0 => false
" - setting          : /path/to/plugin/setting.vim
" - cmd              : cmd to load plugin on (for plugin manager with async plugin loading only)
" - post_update_hook : cmd to run after a plugin update
let g:cvim_plugins = {}

" Vim Startup time
let cvim_plugins.vim_startuptime = { 'name': 'dstein64/vim-startuptime', 'lazy': 1, 'cmd': 'StartupTime' }
" Master Vim's advanced motion and search
let cvim_plugins.vim_hardtime = { 'name': 'takac/vim-hardtime', 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/vim-hardtime.vim" }
" Ease motions
let cvim_plugins.vim_easymotion = { 'name': 'Lokaltog/vim-easymotion', 'lazy': 1, }
" Repeat a plugin map with .
let cvim_plugins.vim_repeat = { 'name': 'tpope/vim-repeat', 'lazy': 1, }
" Working with word viriants
let cvim_plugins.vim_abolish = { 'name': 'tpope/vim-abolish', 'lazy': 1, }
" Ease aligning things (table, field, etc ...)
let cvim_plugins.vim_easy_align = { 'name': 'junegunn/vim-easy-align', 'lazy': 1, }
" Operations on surroundings parentheses, brackets, 
" quotes, XML tags, and more
let cvim_plugins.vim_surround = { 'name': 'tpope/vim-surround', 'lazy': 1, }
" Visualize Vim Undo Tree
if g:vimFlavor ==# g:VIM_FLAVOR_VIM
    " vim + neovim support, without newer updates
    let cvim_plugins.gundo = { 'name': 'sjl/gundo.vim', 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/gundo.vim" }
elseif g:vimFlavor ==# g:VIM_FLAVOR_NEOVIM
    " vim + neovim support, with newer updates (gundo.vim fork),
    let cvim_plugins.vim_mundo = { 'name': 'simnalamburt/vim-mundo'     , 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/mundo.vim" }
endif
" Color schemes
let cvim_plugins.vim_colorschemes = { 'name': 'flazz/vim-colorschemes', 'lazy': 1, }
" Make gvim-only colorscheme work transparently in vim terminal
let cvim_plugins.csapprox = { 'name': 'vim-scripts/CSApprox', 'lazy': 1, }
" Commenting
let cvim_plugins.nerdcommenter = { 'name': 'scrooloose/nerdcommenter', 'lazy': 1, }
" Align things
let cvim_plugins.tabular = { 'name': 'godlygeek/tabular', 'lazy': 1, }
" Syntastic
" C++/C/X*ML/JSON/Javascript .. syntax checking plugin
let cvim_plugins.syntastic = { 'name': 'scrooloose/syntastic', 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/syntastic.vim" }
" NeoMake
let cvim_plugins.neomake={ 'name': 'neomake/neomake', 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/neomake.vim" }
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
" FIXME: where to move rtp += ...fzf to ?
set rtp +=/usr/local/opt/fzf
let cvim_plugins.fzf = { 'name': 'junegunn/fzf.vim', 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/fzf.vim" }
" Show a VCS diff using Vim's sign column. 
let cvim_plugins.vim_signify = { 'name': 'mhinz/vim-signify', 'lazy': 1, }
" Class outliner
let cvim_plugins.tagbar = { 'name': 'majutsushi/tagbar', 'lazy': 1, }
" Lightweight status bar
let cvim_plugins.vim_airline = { 'name': 'bling/vim-airline', 'lazy': 1, }
" Org mode
if g:vimFlavor ==# g:VIM_FLAVOR_VIM
    let cvim_plugins.vim_orgmode = { 'name': 'jceb/vim-orgmode', 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/vim-orgmode.vim" }
elseif g:vimFlavor ==# g:VIM_FLAVOR_NEOVIM
    let cvim_plugins.orgmode = { 'name': 'nvim-orgmode/orgmode'     , 'lazy': 1, }
    " Calendar
    " needed by: vim-orgmode
    let cvim_plugins.calendar_vim = { 'name': 'mattn/calendar-vim', 'lazy': 1, }
    " Use CTRL-A/CTRL-X to increment dates, times, and more
    " needed by: vim-orgmode
    let cvim_plugins.vim_speeddating = { 'name': 'tpope/vim-speeddating', 'lazy': 1, }
endif
" Display vertical thin lines at each indentation level for code
" indented with spaces
let cvim_plugins.indentline = { 'name': 'Yggdroot/indentLine', 'lazy': 1, }
" Diff swap and content file
let cvim_plugins.recover = { 'name': 'chrisbra/Recover.vim', 'lazy': 1, }
" Sublime Text's muliple selection
let cvim_plugins.vim_multiple_cursors = { 'name': 'terryma/vim-multiple-cursors', 'lazy': 1, }
" Rename a buffer within Vim and on the disk
let cvim_plugins.rename = { 'name': 'danro/rename.vim', 'lazy': 1, }
" Support for JSON syntax highlighting
let cvim_plugins.vim_json = { 'name': 'leshill/vim-json', 'lazy': 1, }
" Git wrapper
let cvim_plugins.vim_fugitive = { 'name': 'tpope/vim-fugitive', 'lazy': 1, }
" Zoom in/out window
let cvim_plugins.zoomwin = { 'name': 'vim-scripts/ZoomWin', 'lazy': 1, }
" Character encoding value
" (improves over :ga)
let cvim_plugins.vim_characterize = { 'name': 'tpope/vim-characterize', 'lazy': 1, }
" Show vim's marks
let cvim_plugins.vim_signature = { 'name': 'kshenoy/vim-signature', 'lazy': 1, }
" Enhanced Javascript syntax with support for ES6
" (based on 'jelera/vim-javascript-syntax')
let cvim_plugins.yajs = { 'name': 'othree/yajs.vim', 'lazy': 1, }
" Continously update vim session files
let cvim_plugins.vim_obsession = { 'name': 'tpope/vim-obsession', 'lazy': 1, }
" - Extends tpope/vim-obsession to support 1 vim session per directory
let cvim_plugins.vim_prosession = { 'name': 'dhruvasagar/vim-prosession', 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/vim-prosession.vim" }
" Markdown Live Preview
let cvim_plugins.vim_xmark = { 'name': 'junegunn/vim-xmark', 'lazy': 1, 'post_update_hook': 'make' }
" Restructed Text support
let cvim_plugins.vim_rst = { 'name': 'habamax/vim-rst', 'lazy': 1, }
" Shell script formatting
let cvim_plugins.vim_shfmt = { 'name': 'z0mbix/vim-shfmt', 'lazy': 1, 'filetype': 'sh' }
" Central place for cheatsheets:
" - collect cheatsheets from myself: ~/.vim/cheats/cheat40.txt
" - collect cheatsheets from other plugins
let cvim_plugins.vim_cheat40 = { 'name': 'lifepillar/vim-cheat40', 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/cheat40.vim" }
" Open up a cheat sheet (from learnXinYminutes) for a given language in a vertical split on the right. 
let cvim_plugins.vim_cheat_x_in_y = { 'name': 'jdonaldson/vim-cheat-x-in-y', 'lazy': 1, }

" Load plugins ...
if g:vimFlavor ==# g:VIM_FLAVOR_VIM
    " ... synchronously
    for key in keys(cvim_plugins)
        let plugin = get(cvim_plugins, key, {})
        let name = get(plugin, 'name', v:null)

        if name isnot v:null
            let options = {}

            let ft = get(plugin, 'filetype', v:null)
            if ft isnot v:null 
                let options['for'] = ft
            end

            let hook = get(plugin, 'post_update_hook', v:null)
            if hook isnot v:null 
                let options['do'] = hook
            end

            Plug name, options
        endif
    endfor
    
    " Initialize plugin system
    call plug#end()

    " Install bundles (on very first vim use) 
    if pluginManagerInstallationRequired
        call F_VimPlug_InstallPlugins()
    endif
elseif g:vimFlavor ==# g:VIM_FLAVOR_NEOVIM
    " ... asynchronously
lua << EOF
    local cvim_plugins = {}
    for k, plugin in pairs(vim.g.cvim_plugins) do
        local name = plugin['name']
        local lazy = plugin['lazy']

        local configFn = function () end
        if plugin['config'] ~= nil then
            configFn = function ()
                vim.cmd("source " .. config) 
            end
        end

        local cmd = nil 
        if plugin['cmd'] ~= nil then
            cmd = plugin['cmd']
        end

        local ft = nil 
        if plugin['filetype'] ~= nil then
            ft = plugin['filetype']
        end

        table.insert(cvim_plugins, {
            name,
            lazy = lazy,
            config = configFn,
            cmd = cmd,
            ft = ft
        })
    end

    require("lazy").setup(cvim_plugins)
EOF
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

" Map leader + localleader keys
:let mapleader = ","
:let maploacalleader = "\\"

" Python
if g:vimFlavor ==# g:VIM_FLAVOR_NEOVIM
    let g:python3_host_prog = $_NEOVIM_PYENV_PYTHON_PATH . "/bin/python"
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
" Backup/Swap/Undo/VimInfo{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backups
" Move backup files to a central location
let s:backupDirPath=vimFlavorRootDir."/cache/backup/".g:vimFlavor
let &backupdir=s:backupDirPath

" Undo
" Move undo files to a central location
let s:undirPath=vimFlavorRootDir."/cache/undo/".g:vimFlavor."//"
let &undodir=s:undirPath
set undofile

" Swap
" Move swap to a central location
let s:directoryPath=vimFlavorRootDir."/cache/swap/".g:vimFlavor."//"
let &directory=s:directoryPath

" VimInfo
" Move viminfo to a central location
" src: https://stackoverflow.com/a/23036077
let &viminfo="%,<800,\'10,/50,:100,h,f0,n".vimFlavorRootDir."/cache/viminfo/".g:vimFlavor.'/viminfo'
"            | |    |   |   |    | |    + viminfo file path
"            | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"            | |    |   |   |    + disable 'hlsearch' loading viminfo
"            | |    |   |   + command-line history saved
"            | |    |   + search history saved
"            | |    + files marks saved
"            | + lines saved each register (old name for <, vi6.2)
"            + save/restore buffer list
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

autocmd BufRead,BufNewFile *.md setlocal spell

" Edit crontab file in place
" src: https://vim.fandom.com/wiki/Editing_crontab
autocmd filetype crontab setlocal nobackup nowritebackup
"" on macOS
au BufEnter /tmp/crontab.* setl backupcopy=yes
"" on macOS
au BufEnter /private/tmp/crontab.* setl backupcopy=yes
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
call F_Load_PluginsSettings(vimFlavor, cvim_plugins)
"}}}
" Commands {{{
call F_Load_Commands('$HOME/.config/cvim/commands')
"}}}
" Key Mappings{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call F_Load_KeyMappings('$HOME/.config/cvim/keymap')
"}}}
" UI Enhancements {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call F_Load_UISettings('$HOME/.config/cvim/ui')
"}}}"
" Help{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load custom helps file 
" - personal cheatsheets
:helptags ~/.config/cvim/doc
"}}}"
" Local vimrc{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call F_Load_LocalVimrc(vimFlavorRootDir.'/local.vim')
"}}}
