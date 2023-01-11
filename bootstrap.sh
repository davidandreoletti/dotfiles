#!/bin/bash
BOOSTRAP_COMMAND=""
DOTFILES_FORCE_INSTALL=false
DOTFILES_PROFILE="perso" 
DOTFILES_DEFAULT_SHELL="zsh"
DOTFILES_PRIVATE_DIR_PATH_SET=false
DOTFILES_PRIVATE_DIR_PATH="`pwd`/../dotfiles-private"
DOTFILES_DIR_PATH="`pwd`"
GREADLINK_BIN="/usr/local/bin/greadlink"

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

    if ! command -v $GREADLINK_BIN > /dev/null 2>&1
    then
        echo "Error: Missing $GREADLINK_BIN. Exiting."
        exit 1
    fi

    if [ ${DOTFILES_FORCE_INSTALL} == false ]; then
        echo "INFO: $user will have symlinked configuration files from $destDir to $sourceDir"
        read -p "WARNING: Some files/folder in $destDir will be overwritten. Are you sure? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "OK :). Symlinking files ...."
        else
            echo "Cancelled"
            exit 0
        fi
    fi


    linkerFile="$(mktemp)"

cat <<- 'EOF' >"$linkerFile"
        #!/bin/bash
        sourceDir="$1"                                                          # eg: /path/to/dotfiles
        destDir="$2"                                                            # eg: $HOME
        subPath="$3"                                                            # eg: .foo/bar/bazfile

        sourcePath="$sourceDir/$subPath"
        destPath="$destDir/$subPath"

        destPath2="$destPath/SENTINEL_VALUE"
        sourcePath2="$sourcePath/SENTINEL_VALUE"

        action=""
        finalDestPath="" 
        finalSourcePath="" 

        while true; do
            destPath2="$(dirname "$destPath2")"
            sourcePath2="$(dirname "$sourcePath2")"

	    # Same dest dir, then do nothing
            [ "$destPath2" = "$destDir" ] && action="nothing" && break

            # Symlink exists
            if [ -L "$destPath2" ];
	    then
		    # If resolved symlink is linking to somewhere in src, no more symlink needed
		    resolvedDestPath2="$(/usr/local/bin/greadlink --canonicalize "$destPath2")"
		    isDestPath2SymlinkingToSourceDir="$(grep -q "$sourceDir" <<< "$resolvedDestPath2"; echo $?)"
		    [ "$isDestPath2SymlinkingToSourceDir" -eq "0" ] && action="nothing" && break

		    # If resolved symlink is not linking to somewhere in src, skip overwriting linking
		    [ -e "$resolvedDestPath2" ] && action="nothing" && break
            else
		    # If no existing (symbolic link), then symlink src/subPath<--dest/subPath
		    [ ! -e "$destPath2" ] && action="symlink" && finalDestPath="$destPath2" && finalSourcePath="$sourcePath2" && break
            fi
        done

        [ "$action" = "symlink" ] && ln -Ffsv "$finalSourcePath" "$finalDestPath"
EOF

    chmod -R 700 "$sourceDir"

    # Symlink files and folders
    for srcDir in "$sourceDir" "$sourceDir/profile/$DOTFILES_PROFILE"
    do
        filterFile="$(mktemp)"
        [ -e "$srcDir/exclude.txt" ] && filterFile="$srcDir/exclude.txt" || echo "NO_PATH_WILL_BE_MATECHD" > "$filterFile"
        local sourceExcluded="$(filter_out_comments "$filterFile")"
        count=`echo -n "$srcDir   " | wc -c`
        find "$srcDir/" -type d -o -type f | cut -c$((count - 0))- | \
            grep -f "$sourceExcluded" --invert-match | \
            xargs -I '%' -L1 bash "$linkerFile" "$srcDir" "$destDir" %
            #xargs -P4 -t -I '%' -L1 bash "$linkerFile" "$srcDir" "$destDir"
    done
}

function bootstrap_dotfiles() {
    bootstrap_symlinking_user_files "$USER" "$DOTFILES_DIR_PATH" "$HOME"
}

function bootstrap_oh_my_shell() {
    # - OSX:      . ~/.oh-my-shell/oh-my-shellrc into ~/.bash_profile ("Interactive Login"/"Interactive" shell)
    # - Ubuntu:   . ~/.oh-my-shell/oh-my-shellrc into ~/.bash_profile ("Interactive Login" shell)
    #                                               into ~/.bashrc       ("Interactive" shell)
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
    touch "$shell_file"

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

function bootstrap_dotfiles_private() {
    if [ ${DOTFILES_PRIVATE_DIR_PATH_SET} == false ]; then
        echo "WARNING: No dotfiles-private dir set"
        return
    fi    

    # Simplify private dir path
    DOTFILES_PRIVATE_DIR_PATH="$($GREADLINK_BIN --canonicalize "$DOTFILES_PRIVATE_DIR_PATH")"

    if [ "$($DOTFILES_PRIVATE_DIR_PATH/bin/dotfiles_private_locked_status $DOTFILES_PRIVATE_DIR_PATH )" = "LOCKED" ];
    then
        echo "WARNING: $DOTFILES_PRIVATE_DIR_PATH's files are LOCKED (ie ENCRYPTED). Symlinking fils requires unlocked files."
        echo "To unlock files, run: bash $DOTFILES_PRIVATE_DIR_PATH/bin/dotfiles_private_unlock \"$DOTFILES_PRIVATE_DIR_PATH\""
    else
        echo "NOTE: $DOTFILES_PRIVATE_DIR_PATH's files are UNLOCKED (ie DECRYPTED)."
        bootstrap_symlinking_user_files "$USER" "$DOTFILES_PRIVATE_DIR_PATH" "$HOME"
    fi
}

function oh_my_shell_ready() {
    echo "oh_my_shell is ready. Open a new terminal to start using it"
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
    "macosx") bootstrap_macosx ;;
    "fedora") bootstrap_fedora ;;
    "debian") bootstrap_debian ;;
    "dotfiles") check_new_updates; check_new_shell_exists && change_default_shell; bootstrap_dotfiles; bootstrap_oh_my_shell; bootstrap_dotfiles_private; oh_my_shell_ready ;;
    *) >&2 echo "Command invalid. $0 -h for help" ;;
esac
popd 1> /dev/null 2>&1
