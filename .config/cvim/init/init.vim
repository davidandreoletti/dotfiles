" Vim distribution detection {{{
source $HOME/.config/cvim/bootstrap/distribution.vim
let g:vimDistribution = F_Get_Vim_Distribution()
let g:vimDistributionRootDir = F_Get_Vim_Distribution_Root_Dir() 

source $HOME/.config/cvim/bootstrap/feature.vim

let g:distribFeatureFlags = {
    \    'bye_vi':                F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'leader':                F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'general':               F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'status_line':           F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'internal_encoding':     F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'matchit_bracket':       F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'file_autoread':         F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'ruler_cursor_position': F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'commandbar_height':     F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'terminal_title':        F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'theme':                 F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'syntax':                F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'backup_location':       F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'undo_location':         F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'swap_location':         F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'viminfo_location':      F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'completion':            F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'indentation':           F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'backspace':             F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'search':                F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'mouse':                 F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'fileformat_endofline':  F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'markdown_spell':        F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'crontab_inplace_edit':  F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'character_hidden':      F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'matchit':               F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'encryption':            F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'scrolling':             F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'plugin_settings':       F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'command':               F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'keymap':                F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'ui_enhancement':        F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'local_vimrc':           F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:false, v:false),
    \}

let g:distribKeymapNormalModeFlags = {
    \    '*':  F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \    'toggleUndoTree':  F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false),
    \}

let g:distribKeymapVisualModeFlags = {
    \    '*':  F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false), 
    \    '':  F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false) ,
    \}

let g:distribKeymapInsertModeFlags = {
    \    '*':  F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false) ,
    \    'fast_switch_to_normal_mode':  F_FeatureEnabledOn(g:vimDistribution, v:true, v:true, v:true, v:false) ,
    \}

let g:distribKeymapFlags = {
    \    'n': g:distribKeymapNormalModeFlags,
    \    'v': g:distribKeymapVisualModeFlags,
    \    'i': g:distribKeymapInsertModeFlags,
    \}


"}}}

let g:cvimFeatureDebugLoading = 0
let g:cvimFeaturePath = expand($HOME)."/.config/cvim/feature"

source $HOME/.config/cvim/common/functions.vim
"}}}


call F_Feature(g:distribFeatureFlags, g:vimDistribution, "bye_vi")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "leader")

" Package Manager{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install/load package manager
if g:vimDistribution ==# g:VIM_FLAVOR_VIM
    let pluginManagerInstallationRequired = F_VimPlug_IsInstalled()
    if pluginManagerInstallationRequired
        call F_VimPlug_Install()
    endif

    call plug#begin(vimDistributionRootDir.'/bundle')
elseif g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
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
    -- Added *.lua file into module search path
    -- vim.opt.rtp:prepend("$HOME/.config/cvim/settings")
    package.path = os.getenv("HOME") .. "/.config/cvim/settings/?.lua;" .. package.path
EOF
endif

" Managed plugins{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 'Generic Plugin Manager'
" ------------------------------------------------------------------------------------------------------------------------------------------------------------------
" | Generic Option   | Vim-Plug equiv          | Lazy equiv         | Description                                                                                  |
" ------------------------------------------------------------------------------------------------------------------------------------------------------------------
" | lazy             | ?                       | lazy               | 1 => true, 0 => false                                                                        |
" | setting          | ?                       | config             | /path/to/plugin/setting.vim                                                                  |
" | cmd              | on                      | cmd                | cmd to load plugin on (for plugin manager with async plugin loading only)                    |
" | event            | ?                       | event              | event to load plugin on (for plugin manager with async plugin loading only)                  |
" | keys             | ?                       | keys               | keys to load plugin on (for plugin manager with async plugin loading only)                   |
" | filetype         | for                     | filetype           | filetype to load plugin on (for plugin manager with async plugin loading only)               |
" | post_update_hook | do                      | build              | cmd to run after a plugin update                                                             |
" | dir              | dir                     | dir                | dir is a path to a local plugin's directory                                                  |
" | dependencies     | ?                       | dependencies       | {'dep/one': {lazy: 1}, 'dep2/foo': {lazy: 1}}                                                |
" ------------------------------------------------------------------------------------------------------------------------------------------------------------------
let g:cvim_plugins = {}

" Vim Startup time
if g:vimDistribution ==# g:VIM_FLAVOR_VIM
    let cvim_plugins.vim_startuptime = { 'name': 'dstein64/vim-startuptime', 'lazy': 1, 'cmd': 'StartupTime' }
endif
" Master Vim's advanced motion and search
let cvim_plugins.vim_hardtime = { 'name': 'takac/vim-hardtime', 'lazy': 1,  'cmd': [ 'HardTimeOn', 'HardTimeOff', 'HardTimeToggle'], 'setting': "$HOME/.config/cvim/settings/vim-hardtime.vim" }
" Ease motions
if g:vimDistribution ==# g:VIM_FLAVOR_VIM
    let cvim_plugins.vim_easymotion = { 'name': 'easymotion/vim-easymotion', 'setting': "$HOME/.config/cvim/settings/vim-easymotion.vim"}
elseif g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
    " vim-easymotion not compatible with nvim's LSP. Using hop.nvim instead
    let cvim_plugins.hop_nvim = { 'name': 'smoka7/hop.nvim', 'lazy': 1, 'cmd': ['HopChar1', 'HopChar2', 'HopLine', 'HopLineStart', 'HopVertical', 'HopPattern', 'HopWord'] , 'keys': '<Leader><Leader>s' , 'setting': "$HOME/.config/cvim/settings/nvim_hop.lua"}
endif
" Repeat a plugin map with .
let cvim_plugins.vim_repeat = { 'name': 'tpope/vim-repeat', }
" Working with word variants
let cvim_plugins.vim_abolish = { 'name': 'tpope/vim-abolish', 'lazy': 1, 'cmd': ['Abolish', 'Subvert']}
" Ease aligning things (table, field, etc ...)
let cvim_plugins.vim_easy_align = { 'name': 'junegunn/vim-easy-align', 'lazy': 1, 'cmd': 'EasyAlign', 'keys': 'ga' , 'setting': "$HOME/.config/cvim/settings/vim-easy-align.vim"}
" Operations on surroundings parentheses, brackets, 
" quotes, XML tags, and more
let cvim_plugins.vim_surround = { 'name': 'tpope/vim-surround', 'lazy': 1, }
" Show available keybindings.
" FIXME: To enable with https://github.com/AckslD/nvim-whichkey-setup.lua for neovim
"let cvim_plugins.vim_which_key = { 'name': 'liuchengxu/vim-which-key', 'lazy': 1, 'cmd': ['WhichKey'] ,'setting': "$HOME/.config/cvim/settings/vim-which-key.vim" }""
" Visualize Vim Undo Tree
let cvim_plugins.vim_mundo = { 'name': 'simnalamburt/vim-mundo' , 'lazy': 1, 'cmd': 'MundoToggle' , 'setting': "$HOME/.config/cvim/settings/mundo.vim" }
" Easymotion equivalent for the current line only, always on.
" DISABLED UNTIL this issue is fixed: https://github.com/unblevable/quick-scope/issues/98
"let cvim_plugins.quickscope = { 'name': 'unblevable/quick-scope', 'lazy': 1, 'keys': 'f' ,'setting': "$HOME/.config/cvim/settings/quick-scope.vim" }"
" Color schemes
let cvim_plugins.vim_colorschemes = { 'name': 'vim/colorschemes', 'lazy': 0, }
" Commenting
let cvim_plugins.nerdcommenter = { 'name': 'scrooloose/nerdcommenter', 'lazy': 1, 'keys': '<leader>cc' ,'cmd': [ 'NERDCommenterComment','NERDCommenterNested','NERDCommenterToggle','NERDCommenterMinimal','NERDCommenterInvert','NERDCommenterSexy','NERDCommenterYank','NERDCommenterToEOL','NERDCommenterAppend','NERDCommenterInsert','NERDCommenterAltDelims','NERDCommenterAlignLeft','NERDCommenterAlignBot','NERDCommenterUncomment' ] }
" Align things
let cvim_plugins.tabular = { 'name': 'godlygeek/tabular', 'lazy': 1, 'cmd': 'Tabularize'}
" Syntastic
" Syntax checking / semantic error plugin
if g:vimDistribution ==# g:VIM_FLAVOR_VIM
    "Lazy load but then ALE works only when typing :ALEInfo first
    " => let cvim_plugins.ale = { 'name': 'dense-analysis/ale', 'cmd': [ 'ALEFix', 'ALEGoToDefinition', 'ALEFindReferences', 'ALEHover', 'ALESymbolSearch', 'ALEInfo' ] ,'setting': "$HOME/.config/cvim/settings/ale.vim" }
    "So no lazy load for now 
    let cvim_plugins.ale = { 'name': 'dense-analysis/ale' ,'setting': "$HOME/.config/cvim/settings/ale.vim" }
elseif g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
    " Auto completion 
    let cvim_plugins.nvim_cmp = { 'name': 'hrsh7th/nvim-cmp', 'setting': "$HOME/.config/cvim/settings/nvim_nvim-cmp.lua" }
    " LSP source for auto completion
    let cvim_plugins.nvim_cmp = { 'name': 'hrsh7th/cmp-nvim-lsp', 'lazy': 1, 'dependencies': { 'hrsh7th/nvim-cmp':{'lazy': 1} }, }
    " mason: Language Server Protocols binary installer
    let cvim_plugins.mason = { 'name': 'williamboman/mason.nvim', 'setting': "$HOME/.config/cvim/settings/nvim_mason.lua" }
    " Bridge layer between lspconfig and mason
    let cvim_plugins.mason_lspconfig = { 'name': 'williamboman/mason-lspconfig.nvim', 'dependencies': { 'williamboman/mason.nvim':{'lazy': 1} }, 'setting': "$HOME/.config/cvim/settings/nvim_mason-lspconfig.lua" }
    " lspconfig: LSP client config
    let cvim_plugins.lspconfig = { 'name': 'neovim/nvim-lspconfig', 'dependencies': { 'williamboman/mason-lspconfig.nvim':{'lazy': 1} }, 'setting': "$HOME/.config/cvim/settings/nvim_lspconfig.lua" }
    " treesitter
    let cvim_plugins.treesitter = { 'name': 'nvim-treesitter/nvim-treesitter', 'post_update_hook': ':TSUpdate', 'setting': "$HOME/.config/cvim/settings/nvim_treesitter.lua" }
endif

" Fuzzy Finder: fzf: binary integration
" - provides fzf binary location per platform
"                 macOS x86_64          macOS arm64              # Linux x86_64/arm64
let fzf_dir_path="/tmp/does/not/exists"
for dir_path in [ '/usr/local/opt/fzf', '/opt/homebrew/opt/fzf', '/home/linuxbrew/.linuxbrew/opt/fzf' ]
    if isdirectory(dir_path)
        let fzf_dir_path=dir_path
        break
    endif
endfor
let cvim_plugins.fzf = { 'name': 'junegunn/fzf', 'dir': dir_path }
" Fuzzy Finder: fzf: vim+binary integration
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
" NOTES:
" - fzf replaces Ctrl-P, FuzzyFinder and Command-T)
" - fzf is really fast compared to Crtl-P' vimL fuzy finder implementation
let cvim_plugins.fzfvim = { 'name': 'junegunn/fzf.vim', 'lazy': 1, 'cmd': ['Files', 'GFiles', 'Buffers', 'Colors', 'Ag', 'Rg', 'RG', 'Lines', 'Blines', 'Tags', 'BTags', 'Changes', 'Marks', 'Jumps', 'Windows', 'Locate', 'History', 'Snippets', 'Commits', 'BCommits', 'Commands', 'Maps', 'Helptags', 'Filetypes' ], 'setting': "$HOME/.config/cvim/settings/fzf.vim" }
" Show a VCS diff using Vim's sign column. 
let cvim_plugins.vim_signify = { 'name': 'mhinz/vim-signify', 'setting': "$HOME/.config/cvim/settings/vim-signify.vim" }
" Class outliner
let cvim_plugins.tagbar = { 'name': 'preservim/tagbar' }
" Lightweight status bar
let cvim_plugins.vim_airline = { 'name': 'vim-airline/vim-airline', 'setting': "$HOME/.config/cvim/settings/vim-airline.vim" }
let cvim_plugins.vim_airline_themes = { 'name': 'vim-airline/vim-airline-themes' }
" Org mode
if g:vimDistribution ==# g:VIM_FLAVOR_VIM
    let cvim_plugins.vim_orgmode = { 'name': 'jceb/vim-orgmode', 'lazy': 1, 'setting': "$HOME/.config/cvim/settings/vim_vim-orgmode.vim" }
    " Calendar
    " needed by: vim-orgmode
    let cvim_plugins.calendar_vim = { 'name': 'mattn/calendar-vim', 'lazy': 1, }
    " Use CTRL-A/CTRL-X to increment dates, times, and more
    " needed by: vim-orgmode
    let cvim_plugins.vim_speeddating = { 'name': 'tpope/vim-speeddating', 'lazy': 1, }
elseif g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
    let cvim_plugins.orgmode = { 'name': 'nvim-orgmode/orgmode' , 'lazy': 1, 'event': 'VeryLazy', 'dependencies': { 'nvim-treesitter/nvim-treesitter':{'lazy': 1} }, 'setting': "$HOME/.config/cvim/settings/neovim_orgmode.lua" }
endif
" Display vertical thin lines at each indentation level for code
" indented with spaces
if g:vimDistribution ==# g:VIM_FLAVOR_VIM
    let cvim_plugins.vim_indentguides = { 'name': 'thaerkh/vim-indentguides', 'setting': "$HOME/.config/cvim/settings/vim_vim-indent-guides.vim", }
elseif g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
    let cvim_plugins.indent_blankline = { 'name': 'lukas-reineke/indent-blankline.nvim', 'setting': "$HOME/.config/cvim/settings/neovim_indent-blankline.lua", }
endif
" Diff swap and content file
let cvim_plugins.recover = { 'name': 'chrisbra/Recover.vim', }
" Sublime Text's muliple selection
let cvim_plugins.vim_multiple_cursors = { 'name': 'mg979/vim-visual-multi', }
" Rename a buffer within Vim and on the disk
let cvim_plugins.rename = { 'name': 'danro/rename.vim', 'lazy': 1, 'cmd': 'Rename'}
" Support for JSON syntax highlighting
let cvim_plugins.vim_json = { 'name': 'elzr/vim-json', 'lazy': 1, 'filetype': 'json'}
" Support for autofixing JSON files 
let cvim_plugins.vim_json = { 'name': 'rhysd/vim-fixjson', 'lazy': 1, 'filetype': 'json'}
" Git wrapper
let cvim_plugins.vim_fugitive = { 'name': 'tpope/vim-fugitive', }
" Character encoding value
" (improves over vim's builtin ':ga')
let cvim_plugins.vim_characterize = { 'name': 'tpope/vim-characterize', 'cmd': 'Characterize' } " NOTE: 'ga' key bound by vim-easy-align
" Show vim's marks
let cvim_plugins.vim_signature = { 'name': 'kshenoy/vim-signature', }
" Continously update vim session files
let cvim_plugins.vim_obsession = { 'name': 'tpope/vim-obsession' , 'setting': "$HOME/.config/cvim/settings/vim-obsession.vim" }
" - Extends tpope/vim-obsession to support 1 vim session per directory
let cvim_plugins.vim_prosession = { 'name': 'dhruvasagar/vim-prosession', 'dependencies': { 'tpope/vim-obsession': {'lazy': 0} } ,'setting': "$HOME/.config/cvim/settings/vim-prosession.vim" }
" Markdown Live Preview
if g:vimDistribution ==# g:VIM_FLAVOR_VIM
    let cvim_plugins.markdown_preview = { 'name': 'iamcco/markdown-preview.nvim', 'lazy': 1, 'cmd': [ "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" ] , 'filetype': 'markdown' , 'post_update_hook': { -> mkdp#util#install() },  }
elseif g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
    let cvim_plugins.markdown_preview = { 'name': 'iamcco/markdown-preview.nvim', 'lazy': 1, 'cmd': [ "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" ] , 'filetype': 'markdown' , }
endif

" Restructed Text support
if g:vimDistribution ==# g:VIM_FLAVOR_VIM
    let cvim_plugins.vim_rst = { 'name': 'habamax/vim-rst', }
elseif g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
    " -- Treesitter
endif
" Shell script formatting
let cvim_plugins.vim_shfmt = { 'name': 'z0mbix/vim-shfmt', 'lazy': 1, 'filetype': 'sh' }
" Central place for cheatsheets:
" - collect cheatsheets from myself: ~/.vim/cheats/cheat40.txt
" - collect cheatsheets from other plugins
let cvim_plugins.vim_cheat40 = { 'name': 'lifepillar/vim-cheat40', 'lazy': 1, 'keys': "<leader>?" , 'setting': "$HOME/.config/cvim/settings/cheat40.vim" }
" - collect cheatsheets from myself: ~/.config/cvim_plugins/p-cheatsheet
"   - 'setting': "$HOME/.config/cvim/settings/p-cheatsheet.vim" }
let g:p_cheatsheet_path = $HOME . '/.config/cvim_plugins/p-cheatsheet'
set rtp+=g:p_cheatsheet_path
" Open up a cheat sheet (from learnXinYminutes) for a given language in a vertical split on the right. 
let cvim_plugins.vim_cheat_x_in_y = { 'name': 'jdonaldson/vim-cheat-x-in-y', 'lazy': 1, 'cmd': 'ToggleCheat' }

" Load plugins ...
if g:vimDistribution ==# g:VIM_FLAVOR_VIM
    " ... synchronously
    for key in keys(cvim_plugins)
        let plugin = get(cvim_plugins, key, {})
        let name = get(plugin, 'name', v:null)

        if name isnot v:null
            let options = {}

            let dir = get(plugin, 'dir', v:null)
            if dir isnot v:null 
                let options['dir'] = dir
            end

            let ft = get(plugin, 'filetype', v:null)
            if ft isnot v:null 
                let options['for'] = ft
            end

            let cmd = get(plugin, 'cmd', v:null)
            if cmd isnot v:null 
                let options['on'] = cmd
            end

            let F_Hook = get(plugin, 'post_update_hook', v:null)
            if F_Hook isnot v:null 
                let options['do'] = F_Hook
            end

            let setting = get(plugin, 'setting', v:null)
            if setting isnot v:null 
                " do nothing here. See F_Load_PluginsSettings
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
elseif g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
    " ... asynchronously
lua << EOF
    local cvim_plugins = {}
    for k, plugin in pairs(vim.g.cvim_plugins) do
        local name = plugin['name']

        local dir = nil 
        if plugin['dir'] ~= nil then
            -- lazy detect local plugin using 'dir'
            dir = plugin['dir']
        end

        local lazy = nil 
        if plugin['lazy'] ~= nil then
            lazy = plugin['lazy']
        end

        local configFn = function () end
        if plugin['setting'] ~= nil then
            local file = plugin['setting']
            local file_extension = file:match("[^.]+$")

            local file_name = file:match("[^/]+$")
            local module_name = string.gsub(file_name, "." .. file_extension, "")

            if file_extension == "lua" then
                local pluginModule = require(module_name)                
                configFn = pluginModule.config
            elseif file_extension == "vim" then
                configFn = function ()
                    vim.cmd("source " .. file) 
                end
            else
                print("No handler for ".. file )
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

        local keys = nil 
        if plugin['keys'] ~= nil then
            keys = plugin['keys']
        end

        local build = nil 
        if plugin['post_update_hook'] ~= nil then
            build = plugin['post_update_hook']
        end

        local evt = nil 
        if plugin['event'] ~= nil then
            evt = plugin['event']
        end

        local dependencies = nil
        if plugin['dependencies'] ~= nil then
            dependencies = {} 
            for dependency_name, dependency in pairs(plugin['dependencies']) do
                local dependency_lazy = nil
                if dependency['lazy'] ~= nil then
                    dependency_lazy = dependency['lazy']
                end

                table.insert(dependencies, { dependency_name, lazy = dependency_lazy })
            end 
        end

        table.insert(cvim_plugins, {
            name,
            lazy = lazy,
            config = configFn,
            cmd = cmd,
            keys = keys,
            build = build,
            dir = dir,
            ft = ft,
            dependencies = dependencies,
            event = evt
        })
    end

    require("lazy").setup(cvim_plugins)
EOF
endif
"}}}

call F_Feature(g:distribFeatureFlags, g:vimDistribution, "general")

call F_Feature(g:distribFeatureFlags, g:vimDistribution, "status_line")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "internal_encoding")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "pastetoggle_auto")

call F_Feature(g:distribFeatureFlags, g:vimDistribution, "matchit_bracket")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "file_autoread")

call F_Feature(g:distribFeatureFlags, g:vimDistribution, "ruler_cursor_position")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "commandbar_height")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "terminal_title")

call F_Feature(g:distribFeatureFlags, g:vimDistribution, "theme")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "syntax")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "backup_location")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "undo_location")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "swap_location")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "viminfo_location")

call F_Feature(g:distribFeatureFlags, g:vimDistribution, "completion")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "indentation")

call F_Feature(g:distribFeatureFlags, g:vimDistribution, "backspace")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "search")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "mouse")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "fileformat_endofline")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "markdown_spell")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "crontab_inplace_edit")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "character_hidden")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "matchit")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "encryption")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "scrolling")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "plugin_settings")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "command")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "history")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "mode")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "mapping_timeout")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "keymap")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "ui_enhancement")
call F_Feature(g:distribFeatureFlags, g:vimDistribution, "local_vimrc")

