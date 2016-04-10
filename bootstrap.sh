#!/bin/bash
BOOSTRAP_COMMAND=""
DOTFILES_FORCE_INSTALL=false
DOTFILES_PROFILE="perso" 
DOTFILES_DEFAULT_SHELL="bash"
while getopts b:fs:t:h flag; do
  case $flag in
    b)
      BOOSTRAP_COMMAND="$OPTARG";
      ;;
    f)
      DOTFILES_FORCE_INSTALL=true;
      ;;
    s)
      DOTFILES_PROFILE="$OPTARG";
      ;;
    t)
      DOTFILES_DEFAULT_SHELL="$OPTARG";
      ;;
    h)
      echo "Help: $0.sh -b [command] [options]";
      echo ""
      echo " -h            Show this help."
      echo ""
      echo "COMMAND"
      echo ""
      echo " macosx       Bootstraps a Mac OS X machine."
      echo " debian       Bootstraps a Debian/Ubuntu machine"
      echo " dotfiles     Install dotfiles"
      echo ""
      echo "OPTIONS"
      echo ""
      echo "  MACOSX OPTIONS"
      echo ""
      echo "None"
      echo ""
      echo "  DEBIAN OPTIONS"
      echo ""
      echo "None"
      echo ""
      echo "  DOTFILES OPTIONS"
      echo ""
      echo " -f         Force install."
      echo " -s profile\t dotfiles profile to install. Valid values (case sensitive): "
      echo "    work  - For computers at work."
      echo "    perso - For computers at home (default)."
      echo " -t shell\t Shell type to use by default. Valid values (case sensitive): "
      echo "    bash - Bash shell (default)"
      echo "    zsh  - ZSH shell"
      echo ""
      echo "EXAMPLES"
      echo ""
      echo " 0) Install dotfiles"
      echo ""
      echo "   $0 -b dotfiles -s perso -t bash"
      echo ""
      echo " 1) Bootstraps a MAC OS X machine"
      echo ""
      echo "   $0 -b macosx"
      ;;
    ?)
      echo "Unsupported option. Exit."
      exit;
      ;;
  esac
done

shift $(( OPTIND - 1 ));

# boostrap_*

function check_new_updates() {
    git pull
}

function bootstrap_dotfiles() {
    if [ ${DOTFILES_FORCE_INSTALL} == false ]; then
        read -p " Warning: some dotfiles will be overwritten. Are you sure? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "OK :)"
        else
            echo "Cancelled"
            exit 0
        fi
    fi

	chmod -R 700 .
    echo -n "$USER's "; chsh -s $(which $DOTFILES_DEFAULT_SHELL)
    local rootDir=`pwd`
    find . -maxdepth 1 -type d -o -type f | sed "s|^\./||" |  grep -f "$rootDir/exclude.txt" --invert-match | xargs -I{} bash -c "set -x; cd ~ && ln -Ffsv "$rootDir/{}" ~/{}";

    local profile="custom/${DOTFILES_PROFILE}"
    local curDir="`pwd`/$profile"
	cd "${profile}" && find . -maxdepth 1 -type d -o -type f | sed "s|^\./||" |  grep -f "$rootDir/exclude.txt" --invert-match | xargs -I{} bash -c "set -x; cd ~ && ln -Ffsv "$curDir/{}" ~/{}" && cd - || echo "Cannot find ${profile}. Exit." && exit
    echo "Read .bashrc_stage0 for installation"
}

function bootstrap_macosx() {
    bash "install/bootstrap_macosx.sh"
}

function bootstrap_debian() {
    bash "install/bootstrap_debian.sh"
}

# Main
pushd "$(dirname "${BASH_SOURCE}")"
## Args preconditions
case $BOOSTRAP_COMMAND in
    "macosx") bootstrap_macosx ;;
    "debian") bootstrap_debian ;;
    "dotfiles") check_new_updates; bootstrap_dotfiles ;;
    *) >&2 echo "Command invalid. $0 -h for help" ;;
esac
popd
