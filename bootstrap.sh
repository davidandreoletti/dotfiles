#!/bin/bash
set -e

source $PWD/install/utils/message.sh

BOOSTRAP_COMMAND=""
DOTFILES_PROFILE="perso"
DOTFILES_DEFAULT_SHELL="zsh"
DOTFILES_DIR_PATH="$(pwd)"
DOTFILES_PRIVATE_DIR_PATH_SET=false
DOTFILES_PRIVATE_DIR_PATH="$DOTFILES_DIR_PATH/../dotfiles-private"

# Prefer GNU readlink when available
for bin in "/usr/local/bin/greadlink"; do
    if [ ! -f "$bin" ]; then
        if command -v 'which' >/dev/null 2>&1 && command -v 'readlink' >/dev/null 2>&1; then
            GREADLINK_BIN="$(which readlink)"
        fi

        message_warning_show "$DOTFILES_PRIVATE_DIR_PATH will not be canonicalized"
    else
        # Simplify private dir path
        DOTFILES_PRIVATE_DIR_PATH="$($bin --canonicalize "$DOTFILES_PRIVATE_DIR_PATH")"
    fi
done

. "$DOTFILES_DIR_PATH/install/common/shell/os.sh"
. "$DOTFILES_DIR_PATH/install/common/shell/stow.sh"

# Process program arguments
while getopts 'db:s:t:p:h' flag; do
    case $flag in
        d)
            BASH_DEBUG="-x"
            ;;
        b)
            BOOSTRAP_COMMAND="$OPTARG"
            ;;
        s)
            DOTFILES_PROFILE="$OPTARG"
            ;;
        t)
            DOTFILES_DEFAULT_SHELL="$OPTARG"
            ;;
        p)
            DOTFILES_PRIVATE_DIR_PATH="$OPTARG"
            DOTFILES_PRIVATE_DIR_PATH_SET=true
            ;;
        h)
            echo -e "Help: $0.sh -b [command] [options]"
            echo -e ""
            echo -e " -h            Show this help."
            echo -e ""
            echo -e "COMMAND"
            echo -e ""
            echo -e " machine      Bootstraps a macOS/Fedora/(future:Debian/Ubuntu) machine."
            echo -e " dotfiles     Bootstraps dotfiles"
            echo -e ""
            echo -e " MACHINE OPTIONS"
            echo -e ""
            echo -e " -d"
            echo -e "    \tEnable debug output"
            echo -e ""
            echo -e " DOTFILES OPTIONS"
            echo -e ""
            echo -e " -d"
            echo -e "    \tEnable debug output"
            echo -e ""
            echo -e " -s <profile>"
            echo -e "    \tProfile to install (case sensitive)."
            echo -e ""
            echo -e "    <profile>"
            echo -e "    \tNAME   \t\t-\tSUPPORT\t\t-\tDESCRIPTION"
            echo -e "    \t------------------------------------------------------------------------------------------"
            echo -e "    \tperso  \t\t-\t(dotfiles)\t-\tFor computers at home (default)."
            echo -e "    \twork   \t\t-\t(dotfiles)\t-\tFor computers at work."
            echo -e "    \tnormal \t\t-\t(machine)\t-\tSet as standard user."
            echo -e "    \tadmin  \t\t-\t(machine)\t-\tSet as admin oriented user."
            echo -e "    \tdev_single \t-\t(machine)\t-\tUse if there will be a single developer accounts/users."
            echo -e "    \tdev_multi  \t-\t(machine)\t-\tUse if there will be multiple developer accounts/users."
            echo -e ""
            echo -e " -t <shell>"
            echo -e "    \t Shell type to use by default (case sensitive)."
            echo -e ""
            echo -e "    <shell>"
            echo -e "    \tbash - Bash shell"
            echo -e "    \tzsh  - ZSH shell (default)"
            echo -e ""
            echo -e " -p <path>"
            echo -e "    \t Absolute path to 'dofiles-private' repository. Default: $DOTFILES_PRIVATE_DIR_PATH"
            echo -e ""
            echo -e "EXAMPLES"
            echo -e ""
            echo -e " 0) Bootstraps a macOS/Fedora machine"
            echo -e ""
            echo -e "   a. Setup user account with 'Administrator' role"
            echo -e ""
            echo -e "      > $0 -b machine -s admin"
            echo -e ""
            echo -e "   b. Setup user account per role (single dev, multi dev)"
            echo -e ""
            echo -e "      multi dev => each user accounts is a developer account"
            echo -e ""
            echo -e "      > $0 -b machine -s dev_multi"
            echo -e ""
            echo -e "      single dev => one user account is a developer account"
            echo -e ""
            echo -e "      Run on -the- user account which will be used as the unique development account  (ie single dev machine)"
            echo -e ""
            echo -e "      > $0 -b machine -s dev_single"
            echo -e ""
            echo -e " 1) Install dotfiles + dotfiles-private"
            echo -e ""
            echo -e "    > $0 -b dotfiles -s perso -t bash -p ${DOTFILES_PRIVATE_DIR_PATH}"
            echo -e ""
            ;;
        ?)
            message_error_show "Unsupported option. Exit."
            exit
            ;;
    esac
done

shift $((OPTIND - 1))

# boostrap_*

function check_new_shell_exists() {
    [ -f "$(which $DOTFILES_DEFAULT_SHELL)" ] || (
        message_error_show "Shell $DOTFILES_DEFAULT_SHELL does not exist. EXITING now before trashinng your new setup"
        exit 1
    )
}

function change_default_shell() {
    message_info_show "$USER wants a new shell: $(which $DOTFILES_DEFAULT_SHELL)"
    chsh -s $(which $DOTFILES_DEFAULT_SHELL)
}

# Remove all lines starting with # from a file, inplace
function filter_out_comments() {
    local inFile="$1"
    local outFile="$(mktemp)"
    cat "$inFile" | sed '/^#/d' >"$outFile"
    echo "$outFile"
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
    #         https://apple.stackexchange.com/questions/361870/what-are-the-practical-differences-between-bash-and-zsh

    shell_name="$(basename $SHELL)"
    shell_file="/tmp/.unknownrc"

    # Check shell type
    if [ "$shell_name" = "bash" ]; then
        shell_file="$HOME/.bash_profile"
    elif [ "$shell_name" = "zsh" ]; then
        shell_file="$HOME/.zshrc"
    else
        message_info_show "Error: Shell not supported: $SHELL. Exiting"
        exit 1
    fi

    # Enforce possibly empty file presence
    command touch "$shell_file"

    # Setup oh_my_shellrc entry point when missing
    load_statment=". ~/.oh-my-shell/oh-my-shellrc"

    if ! grep -Fxq "$load_statment" "$shell_file"; then
        echo "Configuring loading oh-my-shell at shell startup: $load_statment ---> $shell_file"
        echo "$load_statment" >>"$shell_file"
    else
        message_info_show "Already configured loading oh-my-shell at shell startup: $load_statment ---> $shell_file"
    fi
}

function bootstrap_homebrew_path() {
    # Load homebrew function dependencies
    . $PWD/.oh-my-shell/shellrc/bootstrap/helper.sh
    . $PWD/.oh-my-shell/shellrc/bootstrap/helper2.sh
    # Set homebrew path in PATH
    homebrew_init
}

function bootstrap_dotfiles() {
    # Symlink config files
    stow_files "$USER" "$DOTFILES_DIR_PATH" "$HOME"

    # Special case: synlink dotfile folder itself
    # - some upgrade scripts from cron rely on it
    ln -s -f "$DOTFILES_DIR_PATH" "$HOME/.dotfiles"
}

function bootstrap_dotfiles_private() {
    if [ ${DOTFILES_PRIVATE_DIR_PATH_SET} == false ]; then
        message_warning_show "WARNING: No dotfiles-private dir set."
        return
    fi

    if [ "$($DOTFILES_PRIVATE_DIR_PATH/.bin/dotfiles_private_locked_status $DOTFILES_PRIVATE_DIR_PATH)" = "LOCKED" ]; then
        message_warning_show "WARNING: $DOTFILES_PRIVATE_DIR_PATH's files are LOCKED (ie ENCRYPTED). Symlinking files requires unlocked files."
        message_info_show "To unlock files, run: bash $DOTFILES_PRIVATE_DIR_PATH/.bin/dotfiles_private_unlock \"$DOTFILES_PRIVATE_DIR_PATH\""
    else
        message_info_show "NOTE: $DOTFILES_PRIVATE_DIR_PATH's files are UNLOCKED (ie DECRYPTED)."
        stow_files "$USER" "$DOTFILES_PRIVATE_DIR_PATH" "$HOME"
    fi
}

bootstrap_dotfiles_binaries() {
    chmod 700 ~/.bin/*
}

function oh_my_shell_ready() {
    message_info_show "oh_my_shell is ready. Open a new terminal to start using it"
}

function bootstrap_vim_plugins() {
    bash $BASH_DEBUG "install/bootstrap_vim_plugins.sh"
}

function bootstrap_os() {
    local os="$1"

    bash $BASH_DEBUG "install/bootstrap_${os}.sh" "$DOTFILES_PROFILE"
}

# Main
pushd "$(dirname "${BASH_SOURCE}")" 1>/dev/null 2>&1
## Args preconditions
case $BOOSTRAP_COMMAND in
    "machine")
        is_macos && bootstrap_os 'macos'
        is_fedora && bootstrap_os 'fedora'
        is_archl && bootstrap_os 'archlinux'
        #is_debian && bootstrap_os 'debian';
        ;;
    "dotfiles")
        # macOS: skippable shell change to prevent this issue on macOS CI runner:
        # - "Password for runner: chsh: Credentials could not be verified, user name or password is invalid.
        #    Credentials could not be verified, user name or password is invalid."
        if test "${BOOTSTRAP_SKIP_SHELL_CHANGE}" = "0"; then
            message_info_show "Skip changing default shell"
        else
            check_new_shell_exists && change_default_shell
        fi
        bootstrap_homebrew_path
        bootstrap_dotfiles
        bootstrap_oh_my_shell
        bootstrap_dotfiles_private
        bootstrap_dotfiles_binaries
        bootstrap_vim_plugins
        oh_my_shell_ready
        ;;
    *) echo >&2 "Command invalid. $0 -h for help" ;;
esac
popd 1>/dev/null 2>&1
