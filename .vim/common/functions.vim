" Load plugins settings as (settings/*.vim)
function! F_Load_PluginsSettings (vimPluginSettingsPath)
    for fpath in split(globpath(a:vimPluginSettingsPath, '*.vim'), '\n')
        exe 'source ' . fpath
    endfor
endfunction

" Load key mapping "plugins" (keymap/*.vim)
function! F_Load_KeyMappings (vimKeyMappingsPath)
    for fpath in split(globpath(a:vimKeyMappingsPath, '*.vim'), '\n')
        exe 'source ' . fpath
    endfor
endfunction

" Load ui "plugins" (ui/*.vim)
function! F_Load_UISettings (uiPath)
    for fpath in split(globpath(a:uiPath, '*.vim'), '\n')
        exe 'source ' . fpath
    endfor
endfunction

" Load commands (commands/*.vim)
function! F_Load_Commands (vimCommandsPath)
    for fpath in split(globpath(a:vimCommandsPath, '*.vim'), '\n')
        exe 'source ' . fpath
    endfor
endfunction

" Load a local vimrc
function! F_Load_LocalVimrc (localVIMRCPath)
    if filereadable(a:localVIMRCPath)
        source a:localVIMRCPath
    endif
endfunction

let g:VIM_FLAVOR_VIM = 'vim'
let g:VIM_FLAVOR_NEOVIM = 'neovim'
let g:VIM_FLAVOR_UNKNOWN = 'unknown'

" Get VIM flavor
" Returns:
" - vim
" - neovim  
" - unknown
function! F_Get_Vim_Flavor ()
    if has('nvim')
        return g:VIM_FLAVOR_NEOVIM
    else
        return g:VIM_FLAVOR_VIM
    endif
endfunction

" Set JAVA doxygen tag
function! F_DoxygenToolKit_SetJAVATags ()
	let g:DoxygenToolkit_throwTag_pre="@throw "
	let g:DoxygenToolkit_classTag="@class "
	let g:DoxygenToolkit_briefTag_pre=""
	let g:DoxygenToolkit_paramTag_pre="@param "
	let g:DoxygenToolkit_returnTag="@return "
endfunction

" Set CPP or C doxygen tag
function! F_DoxygenToolKit_SetCPPOrCTags ()
	let g:DoxygenToolkit_throwTag_pre="\\throw "
	let g:DoxygenToolkit_classTag="\\class "
	let g:DoxygenToolkit_briefTag_pre=""
	let g:DoxygenToolkit_paramTag_pre="\\param "
	let g:DoxygenToolkit_returnTag="\\return "
endfunction

" Indicates if vimplug is installed
" Return: 
function! F_VimPlug_IsInstalled ()
	let vundle_readme=expand('~/.vim/autoload/plug.vim')
	return !filereadable(vundle_readme)
endfunction

" Installs VimPlug
" Return: 0
function! F_VimPlug_Install ()
	echo "Installing VimPlug..."
	echo ""
	silent !mkdir -p ~/.vim/bundle2
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endfunction

" Installs bundles via vimplug
" Return: 0
function! F_VimPlug_InstallPlugins ()
	echo "Installing Bundles(please ignore key map error messages) ..."
	echo ""
	:PlugInstall
endfunction

" Indicates if vundle is installed
" Return: 
function! F_Vundle_IsInstalled ()
	let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
	return !filereadable(vundle_readme)
endfunction

" Installs Vundle
" Return: 0
function! F_Vundle_Install ()
	echo "Installing Vundle..."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
endfunction

" Installs bundles via vundle
" Return: 0
function! F_Vundle_InstallBundles ()
	echo "Installing Bundles(please ignore key map error messages) ..."
	echo ""
	:BundleInstall
endfunction

" Indicates if vim is running on Debian based OS
" 1 if Debian based OS.
function! F_OS_IsDebianBasedOS ()
	if has('unix')
		let s:uname = system("echo -n $(uname -a)") 
		if s:uname =~ ".*Ubuntu.*""
			return 1
		endif
	endif
	return 0
endfunction

" Indicates if vim is running on Mac OS
" 1 if Mac OS.
function! F_OS_IsMacBasedOS ()
	if has('unix')
  		let s:uname = system("echo -n $(uname)")
		if s:uname ==? "Darwin"
			return 1
  		endif
	endif
	return 0
endfunction

" Indicates if vim is running on Arch Linux OS
" 1 if Arch Linux.
function! F_OS_IsArchLinuxBasedOS ()
	if has('unix')
  		let s:uname = system("echo -n $(uname -r)")
		if s:uname =~ ".*ARCH$"
			return 1
  		endif
	endif
	return 0
endfunction

" Installs curl if missing
function! F_Curl_InstallIfMissing ()
	if F_OS_IsDebianBasedOS ()
		silent !sudo apt-get install curl
	elseif F_OS_IsArchLinuxBasedOS ()
		silent !sudo pacman -S curl
	endif
endfunction

" Installs python pip-if missing
function! F_PythonPip_InstallifMissing ()
	if F_OS_IsDebianBasedOS ()
		silent !sudo apt-get install python-pip
	elseif F_OS_IsMacBasedOS ()
		silent !sudo easy_install pip
	elseif F_OS_IsArchLinuxBasedOS ()
		silent !sudo pacman -S python-pip
	endif	
endfunction

" Installs tagbar's dependencies
function! F_Tagbar_InstallDependencies ()
	echo "Installing Tagbar depedencies ..."
	echo ""
	if F_OS_IsMacBasedOS ()
		silent !cd /tmp && curl -L -O http://downloads.sourceforge.net/project/ctags/ctags/5.8/ctags-5.8.tar.gz && tar xzvf ctags-5.8.tar.gz && cd ctags-5.8 && ./configure && make && sudo make install	
	elseif F_OS_IsDebianBasedOS ()
		silent !sudo apt-get install exuberant-ctags
	elseif F_OS_IsArchLinuxBasedOS ()
		silent !sudo pacman -S ctags
	else
		echoerr "Intalling Tagbar dependencies is NOT specified for this platform."	
	endif
endfunction
