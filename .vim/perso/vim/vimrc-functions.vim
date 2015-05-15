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

" Indicates if vundle is installed
" Return: 
function! F_Vundle_IsVundleInstalled ()
	let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
	return !filereadable(vundle_readme)
endfunction

" Installs Vundle
" Return: 0
function! F_Vundle_InstallVundle ()
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

" Installs npm if missing
function! F_npm_InstallifMissing ()
	if F_OS_IsDebianBasedOS ()
		silent !sudo apt-get install npm 
	elseif F_OS_IsMacBasedOS ()
		silent !brew install npm 
	endif	
endfunction

" Installs jshint missing
function! F_jshint_InstallifMissing ()
    silent !npm install jshint -g 
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

"" Installs PowerLine python
"function! F_PowerLine_InstallDependencies ()
	"echo "Installing powerline dependencies"
	"if F_OS_IsDebianBasedOS () || F_OS_IsArchLinuxBasedOS ()
		"call F_Curl_InstallIfMissing()
		"call F_PythonPip_InstallIfMissing()
		"silent !pip install --user git+git://github.com/Lokaltog/powerline
		"echo "Installing patched fonts ..."
		"silent !cd /tmp && cd `mktemp -d` && git clone https://github.com/Lokaltog/powerline-fonts && mkdir -p ~/.fonts && find `pwd`/powerline-fonts -regextype posix-extended -iregex '.*\.(otf|ttf)' -print0 | xargs -0 -I {} cp -v {} ~/.fonts/
		"silent !cd /tmp && cd `mktemp -d` && curl -O -L https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf && mv -v PowerlineSymbols.otf ~/.fonts
		"silent !cd /tmp && cd `mktemp -d` && curl -O -L https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf && mkdir -p ~/.fonts.conf.d/ && mv -v 10-powerline-symbols.conf ~/.fonts.conf.d/ 
		"silent !fc-cache -vf ~/.fonts
		"echo "Change Terminal font to -DejaVu Sans Mono for Powerline- to get nice delimiters in status line"
	"elseif F_OS_IsMacBasedOS ()
		"" Original idea : https://coderwall.com/p/dmhp5q
		"call F_PythonPip_InstallIfMissing()
		"silent !sudo pip install --user https://github.com/Lokaltog/powerline/tarball/develop
		"" Original Idea : http://superuser.com/questions/120700/how-do-i-programatically-install-a-font-on-a-macintosh
		"ho "Installing patched fonts ..."
		"silent !cd /tmp && cd `mktemp -d /tmp/tmp.XXXXX` && git clone https://github.com/Lokaltog/powerline-fonts && find -E `pwd`/powerline-fonts -iregex '.*\.(otf|ttf)' -print0 | xargs -0 -I {} cp -v {} ~/Library/Fonts
         "silent !cd /tmp && cd `mktemp -d /tmp/tmp.XXXXX` && curl -O -L https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf && mv -v PowerlineSymbols.otf ~/Library/Fonts
		""silent !curl -O https://gist.github.com/sjl/1627888/raw/c4e92f81f7956d4ceaee11b5a7b4c445f786dd90/Menlo-ForPowerline.ttc.zip && unzip Menlo-ForPowerline.ttc.zip -d ~/Library/Fonts
		""silent !curl -O https://gist.github.com/baopham/1838072/raw/7ad07f130cc8d792e32d6ae6bd018a4db47537b1/Monaco-Powerline.otf && mv -v Monaco-Powerline.otf ~/Library/Fonts
		"" Font not installed with Font Book even though it would be better - Font Book checks if font to be installed is valid
		"echo "Change Terminal font to -Menlo for Powerline- to get nice delimiters in status line"
	"else
		"echoerr "Intalling Powerline dependencies is NOT specified for this platform."
	"endif
"endfunction
