" Indicates if vundle is installed
" Return: 
function F_Vundle_IsVundleInstalled ()
	let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
	return !filereadable(vundle_readme)
endfunction

" Installs Vundle
" Return: 0
function F_Vundle_InstallVundle ()
	echo "Installing Vundle..."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
endfunction

" Installs bundles via vundle
" Return: 0
function F_Vundle_InstallBundles ()
	echo "Installing Bundles(please ignore key map error messages) ..."
	echo ""
	:BundleInstall
endfunction

" Indicates if vim is running on Debian based OS
" 1 if Debian based OS.
function F_OS_IsDebianBasedOS ()
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
function F_OS_IsMacBasedOS ()
	if has('unix')
  		let s:uname = system("echo -n $(uname)")
		if s:uname ==? "Darwin"
			return 1
  		endif
	endif
	return 0
endfunction

" Install curl if missing
function F_Curl_InstallIfMissing ()
	if F_OS_IsDebianBasedOS ()
		silent !sudo apt-get install curl
	endif
endfunction

" Installs tagbar's dependencies
function F_Tagbar_InstallDependencies ()
	echo "Installing Tagbar depedencies ..."
	echo ""
	if F_OS_IsMacBasedOS ()
		silent !cd /tmp && curl -L -O http://downloads.sourceforge.net/project/ctags/ctags/5.8/ctags-5.8.tar.gz && tar xzvf ctags-5.8.tar.gz && cd ctags-5.8 && ./configure && make && sudo make install	
	elseif F_OS_IsDebianBasedOS ()
		silent !sudo apt-get install exuberant-ctags
	else
		echoerr "Intalling Tagbar dependencies is NOT specified for this platform."	
	endif
endfunction

" Installs PowerLine python
function F_PowerLine_InstallDependencies ()
	echo "Installing powerline dependencies"
	if F_OS_IsDebianBasedOS ()
		call F_Curl_InstallIfMissing()
		silent !sudo apt-get install python-pip
		silent !pip install --user git+git://github.com/Lokaltog/powerline
		echo "Installing patched fonts ..."
		silent !cd /tmp && git clone https://github.com/Lokaltog/powerline-fonts && mkdir -p ~/.fonts && find `pwd`/powerline-fonts -iregex '.*\(otf|ttf\)' -printf '%p\0' | xargs -0 -I {} cp -v {} ~/.fonts/
		silent !curl -O -L https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf && mv -v PowerlineSymbols.otf ~/.fonts
		silent !curl -O -L https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf && mkdir -p ~/.fonts.conf.d/ && mv -v 10-powerline-symbols.conf ~/.fonts.conf.d/ 
		silent !fc-cache -vf ~/.fonts
		echo "Change Terminal font to -DejaVu Sans Mono for Powerline to get nice delimiters in status line"
	else
		echoerr "Intalling Powerline dependencies is NOT specified for this platform."
	endif
endfunction
