#!/bin/bash
FORCE_INSTALL=false
DOTFILESSETUPTYPE="perso" 
SHELLTYPE="bash"
while getopts fs:t:h flag; do
  case $flag in
    f)
      FORCE_INSTALL=true;
      ;;
    s)
      DOTFILESSETUPTYPE="$OPTARG";
      ;;
    t)
      SHELLTYPE="$OPTARG";
      ;;
    h)
      echo "Help: bootstrap.sh [options]";
      echo " -f         Force install."
      echo " -s value\t Setup type to install. Valid values (case sensitive): "
      echo "    work  - For computers at work."
      echo "    perso - For computers at home (default)."
      echo " -t value\t Shell type to use by default. Valid values (case sensitive): "
      echo "    bash - Bash shell (default)"
      echo "    zsh  - ZSH shell"
      echo " -h This help."
      ;;
    ?)
      echo "Unsupported option. Exit."
      exit;
      ;;
  esac
done

shift $(( OPTIND - 1 ));

cd "$(dirname "${BASH_SOURCE}")"
git pull
function doIt() {
	chmod -R 700 .
    echo -n "$USER's "; chsh -s $(which $SHELLTYPE)
	rsync --exclude ".git/" --exclude "custom/" --exclude ".DS_Store" --exclude "bootstrap.sh" --exclude "README.rst" -av . ~
        local p="custom/${DOTFILESSETUPTYPE}"
	cd "${p}" && rsync  -av . ~ && cd - || echo "Cannot find ${p}. Exit." && exit
}
if [ ${FORCE_INSTALL} == true ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt

echo "Read .bashrc_stage0 for installation"
