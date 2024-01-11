#!/bin/bash
BOOSTRAP_COMMAND=""
DOTFILES_FORCE_INSTALL=false
DOTFILES_PROFILE="perso" 
DOTFILES_DEFAULT_SHELL="zsh"
DOTFILES_PRIVATE_DIR_PATH_SET=false
DOTFILES_PRIVATE_DIR_PATH="`pwd`/../dotfiles-private"
DOTFILES_DIR_PATH="`pwd`"

# Get GNU readlink avaiable
GREADLINK_BIN="/usr/local/bin/greadlink"
if [ ! -f "$GREADLINK_BIN" ];
then
	GREADLINK_BIN="$(which readlink)"
fi

while getopts 'b:fs:t:p:h' flag; do
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
      echo " macosx       Bootstraps a macOS machine."
      echo " debian       Bootstraps a Debian/Ubuntu machine"
      echo " fedora       Bootstraps a Fedora machine"
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
      echo "  FEDORA OPTIONS"
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
      echo "    bash - Bash shell"
      echo "    zsh  - ZSH shell (default)"
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
      echo " 3) Bootstraps a macOS/Fedora machine"
      echo ""
      echo "   1. Setup  -the- user account acting as Administrator"
      echo "   $0 -b <macosx/fedora> -s admin"
      echo ""
      echo "   2. Setup depending on the computer's machine purpose: single dev OR multi dev configuration"
      echo "    Run  all user accounts which will be used for development purpose (ie multi dev machine)"
      echo "    $0 -b <macosx/fedora> -s dev_multi"
      echo "    OR"
      echo "    Run on -the- user account which will be used as the unique development account  (ie single dev machine)"
      echo "    $0 -b <macosx/fedora> -s dev_single"
      echo ""
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

function check_new_shell_exists() {
    [ -f "$(which $DOTFILES_DEFAULT_SHELL)" ] || ( echo "Shell $DOTFILES_DEFAULT_SHELL does not exist. EXITING now before trashinng your new setup"; exit 1 )
}

function change_default_shell() {
    echo "INFO: $USER wants a new shell: $(which $DOTFILES_DEFAULT_SHELL)"
    chsh -s $(which $DOTFILES_DEFAULT_SHELL)
}

# Remove all lines starting with # from a file, inplace
function filter_out_comments() {
    local inFile="$1"
    local outFile="$(mktemp)"
    cat "$inFile" | sed '/^#/d' > "$outFile"
    echo "$outFile"
}

function bootstrap_symlinking_user_files() {
    local user="$1"
    local sourceDir="$2"
    local destDir="$3"

    if ! command -v stow > /dev/null 2>&1
    then
        echo "Error: missing GNU stow"
        exit 1
    fi

    local package="$(basename $sourceDir)"
    #stow_options="--simulate"
    stow ${stow_options} --verbose=1 --restow --dir="$(realpath $sourceDir/..)" --target="$(realpath $destDir)" $package
}

function bootstrap_oh_my_shell() {
    # BASH shell:
    # - OSX:      . ~/.oh-my-shell/oh-my-shellrc into ~/.bash_profile ("Interactive Login"/"Interactive" shell)
    # - Ubuntu:   . ~/.oh-my-shell/oh-my-shellrc into ~/.bash_profile ("Interactive Login" shell)
    #                                            into ~/.bashrc       ("Interactive" shell)
    # ZSH shell:
    #
    # - OSX:      . ~/.oh-my-shell/oh-my-shellrc into ~/.zshrc ("Interactive Login"/"Interactive" shell)
    # - Ubuntu:   . ~/.oh-my-shell/oh-my-shellrc into ~/.zshrc ("Interactive Login" shell)
    #
    # Source: http://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
    #         http://tanguy.ortolo.eu/blog/article25/shrc

    shell_name="$(basename $SHELL)"
    shell_file="/tmp/.unknownrc"

    # Check shell type
    if [ "$shell_name"  = "bash" ];
    then
        shell_file="$HOME/.bash_profile"
    elif [ "$shell_name"  = "zsh" ];
    then
        shell_file="$HOME/.zshrc"
    else
        echo "Error: Shell not supported: $SHELL. Exiting"
        exit 1
    fi

    # Enforce possibly empty file presence
    command touch "$shell_file"

    # Setup oh_my_shellrc entry point when missing
    load_statment=". ~/.oh-my-shell/oh-my-shellrc"

    if ! grep -Fxq "$load_statment" "$shell_file";
    then
        echo "Configuring loading oh-my-shell at shell startup: $load_statment ---> $shell_file"
        echo "$load_statment" >> "$shell_file"
    else
        echo "Already configured loading oh-my-shell at shell startup: $load_statment ---> $shell_file"
    fi
}

function bootstrap_dotfiles() {
    bootstrap_symlinking_user_files "$USER" "$DOTFILES_DIR_PATH" "$HOME"
}

function bootstrap_dotfiles_private() {
    if [ ${DOTFILES_PRIVATE_DIR_PATH_SET} == false ]; then
        echo "WARNING: No dotfiles-private dir set."
        return
    fi    

    # Simplify private dir path
    DOTFILES_PRIVATE_DIR_PATH="$($GREADLINK_BIN --canonicalize "$DOTFILES_PRIVATE_DIR_PATH")"

    if [ "$($DOTFILES_PRIVATE_DIR_PATH/bin/dotfiles_private_locked_status $DOTFILES_PRIVATE_DIR_PATH )" = "LOCKED" ];
    then
        echo "WARNING: $DOTFILES_PRIVATE_DIR_PATH's files are LOCKED (ie ENCRYPTED). Symlinking files requires unlocked files."
        echo "To unlock files, run: bash $DOTFILES_PRIVATE_DIR_PATH/bin/dotfiles_private_unlock \"$DOTFILES_PRIVATE_DIR_PATH\""
    else
        echo "NOTE: $DOTFILES_PRIVATE_DIR_PATH's files are UNLOCKED (ie DECRYPTED)."
        bootstrap_symlinking_user_files "$USER" "$DOTFILES_PRIVATE_DIR_PATH" "$HOME"
    fi
}

function oh_my_shell_ready() {
    echo "oh_my_shell is ready. Open a new terminal to start using it"
}

function bootstrap_vim_plugins() {
    bash "install/bootstrap_vim_plugins.sh" 
}

function bootstrap_macosx() {
    bash "install/bootstrap_macosx.sh" "$DOTFILES_PROFILE"
}

function bootstrap_fedora() {
    bash "install/bootstrap_fedora.sh" "$DOTFILES_PROFILE"
}

function bootstrap_debian() {
    bash "install/bootstrap_debian.sh"
}

# Main
pushd "$(dirname "${BASH_SOURCE}")" 1> /dev/null 2>&1 
## Args preconditions
case $BOOSTRAP_COMMAND in
    "macosx") 
        bootstrap_macosx;
        ;;
    "fedora") 
        bootstrap_fedora;
        ;;
    "debian") 
        bootstrap_debian;
        ;;
    "dotfiles") 
        check_new_updates; 
        check_new_shell_exists && change_default_shell; 
        bootstrap_dotfiles;
        bootstrap_oh_my_shell;
        bootstrap_dotfiles_private;
        bootstrap_vim_plugins
        oh_my_shell_ready
        ;;
    *) >&2 echo "Command invalid. $0 -h for help" ;;
esac
popd 1> /dev/null 2>&1
