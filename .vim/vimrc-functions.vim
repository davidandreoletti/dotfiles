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

" Install bundles via vundle
" Return: 0
function F_Vundle_InstallBundles ()
	echo "Installing Bundles(please ignore key map error messages) ..."
	echo ""
	:BundleInstall
endfunction
