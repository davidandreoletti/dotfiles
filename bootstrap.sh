#!/bin/bash
BOOSTRAP_COMMAND=""
DOTFILES_FORCE_INSTALL=false
DOTFILES_PROFILE="perso" 
DOTFILES_DEFAULT_SHELL="bash"
DOTFILES_PRIVATE_DIR_PATH_SET=false
DOTFILES_PRIVATE_DIR_PATH="`pwd`/../dotfiles-private"
DOTFILES_DIR_PATH="`pwd`"

while getopts b:fs:t:p:h flag; do
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
    p)
      DOTFILES_PRIVATE_DIR_PATH="$OPTARG";
      DOTFILES_PRIVATE_DIR_PATH_SET=true
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
      echo " -s profile\t Profile to install. Valid values (case sensitive): "
      echo "    work   - (dotfiles configuration only) For computers at work."
      echo "    perso  - (dotfiles configuration only)For computers at home (default)."
      echo "    normal - (macosx configuration only) Set as standard user."
      echo "    admin  - (macosx configuration only) Set as admin oriented user."
      echo "    dev_single - (macosx configuration only) Use if there will be a single developer accounts/users."
      echo "    dev_multi  - (macosx configuration only) Use if there will be multiple developer accounts/users."
      echo " -t shell\t Shell type to use by default. Valid values (case sensitive): "
      echo "    bash - Bash shell (default)"
      echo "    zsh  - ZSH shell"
      echo " -p dotfiles-private\t Absolute path to repository with dofiles-private files. Default: none"
      echo ""
      echo "EXAMPLES"
      echo ""
      echo " 0) Install dotfiles"
      echo ""
      echo "   $0 -b dotfiles -s perso -t bash"
      echo ""
      echo " 1) Install dotfiles along with dotfiles-private "
      echo ""
      echo "   $0 -b dotfiles -s perso -t bash -p `pwd`/some/path/dotfiles-private"
      echo ""
      echo " 2) Install dotfiles"
      echo ""
      echo "   $0 -b dotfiles -s perso -t bash"
      echo ""

      echo " 1) Bootstraps a MAC OS X machine"
      echo ""
      echo "   1. Setup  -the- user account acting as Administrator"
      echo "   $0 -b macosx -s admin"
      echo "   2. Setup depending on the computer's machine purpose: single dev OR multi dev configuration"
      echo "    Run  all user accounts which will be used for development purpose (ie multi dev machine)"
      echo "    $0 -b macosx -s dev_multi"
      echo "    OR"
      echo "    Run on -the- user account which will be used as the unique development account  (ie single dev machine)"
      echo "    $0 -b macosx -s dev_single"
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

function change_default_shell() {
    echo -n "$USER's "; chsh -s $(which $DOTFILES_DEFAULT_SHELL)
}

function bootstrap_symlinking_user_files() {
    set -x 
    local user="$1"
    local repoRootDir="$2"
    local userHome="$3"
    local dottype="$repoRootDir"

    if [ ${DOTFILES_FORCE_INSTALL} == false ]; then
        read -p " Warning: some $dottype will be overwritten. Are you sure? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "OK :)"
        else
            echo "Cancelled"
            exit 0
        fi
    fi

    #Symlink files and folder in the repo's common profile
    chmod -R 700 "$repoRootDir"
    local repoExcluded="$repoRootDir/exclude.txt"
    count=`echo -n "$repoRootDir   " | wc -c`
    find "$repoRootDir/" -maxdepth 1 -type d -o -type f | cut -c$count- | grep -f "$repoExcluded" --invert-match | xargs -t -I {} bash -c "ln -Ffsv \"$repoRootDir/{}\" \"$userHome/{}\"";

    #Symlink files and folder in the repo's selected profile
    local repoProfile="custom/${DOTFILES_PROFILE}"
    local repoProfileRootDir="`pwd`/$repoProfile"
    local repoProfileExcluded="$repoProfileRootDir/exclude.txt"
    count=`echo -n "$repoProfileRootDir" | wc -c`
    [[ ! -f "$repoProfileExcluded" ]] && touch "$repoProfileExcluded"
    [[ -d "$repoProfileRootDir" ]] && find "$repoProfileRootDir/" -maxdepth 1 -type d -o -type f | cut -c$count- |  grep -f "$repoProfileExcluded" --invert-match | xargs -t -I {} bash -c "ln -Ffsv \"$repoProfileRootDir/{}\" \"$userHome/{}\"" || echo "Cannot find ${repoProfile}. Ignoring."
    set +x
}

function bootstrap_dotfiles() {
    bootstrap_symlinking_user_files "$USER" "$DOTFILES_DIR_PATH" "$HOME"
    echo "Read .bashrc_stage0 for installation"
}

function bootstrap_dotfiles_private() {
    if [ ${DOTFILES_PRIVATE_DIR_PATH_SET} == false ]; then
        return
    fi    

    bootstrap_symlinking_user_files "$USER" "$DOTFILES_PRIVATE_DIR_PATH" "$HOME"
}

function bootstrap_macosx() {
    bash "install/bootstrap_macosx.sh" "$DOTFILES_PROFILE"
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
    "dotfiles") check_new_updates; change_default_shell; bootstrap_dotfiles; bootstrap_dotfiles_private ;;
    *) >&2 echo "Command invalid. $0 -h for help" ;;
esac
popd
