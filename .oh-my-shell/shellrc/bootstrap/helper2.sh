# Keep is_xxx in sync with install/comman/shell/os.sh
is_macos() {
    case "$(uname -sr)" in
        Darwin*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

is_linux() {
    case "$(uname -sr)" in
        Linux*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

is_fedora() {
    case "$(grep -E '^(ID)=' /etc/os-release | cut -d'=' -f 2)" in
        fedora*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

#
# Get os type
#
get_os_type() {
    is_macos && echo "macos" && return 0
    is_linux && echo "linux" && return 0
    echo "unknown" && return 0
}

is_bash() {
    test -n "$BASH_VERSION"
}

is_zsh() {
    test -n "$ZSH_VERSION"
}

# Get shell name
get_shell_type() {
    is_bash && echo "bash" && return 0
    is_zsh && echo "zsh" && return 0
    echo "unknow-shell" && return 0
}

#
# Get terminal application type
#
is_kitty_terminal_app() {
    test -n "$KITTY_WINDOW_ID"
}

is_alacritty_terminal_app() {
    test -n "$ALACRITTY_SOCKET"
}

is_apple_terminal_app() {
    test "$TERM_PROGRAM" = "Apple_Terminal"
}

get_terminal_app_type() {
    is_kitty_terminal_app && echo "kitty" && return 0
    is_alacritty_terminal_app && echo "alacritty" && return 0
    is_apple_terminal_app && echo "apple_terminal" && return 0
    echo "unknown-terminal-app" && return 0
}

#
# Login/interactive shell type
#
is_interactive_shell() {
    # support bash/zsh
    case $- in
        *i*) return 0;;
        *) return 1;;
    esac
}

is_login_shell() {
    if is_bash; then
        shopt -q login_shell && return 0
    elif is_zsh; then
        [[ -o login ]] && return 0
    else
        return 1
    fi
}

homebrew_init() {
    if is_macos; then
        # ARM Silicon
        dir0="/opt/Homebrew/bin"
        # x86 arch                   
        dir1="/usr/local/Homebrew/bin/"
    elif is_linux; then
        dir0="/home/linuxbrew/.linuxbrew/bin"
    fi

    # Homebrew installation added to
    # - PATH
    # - MANPATH
    # - INFOPATH
    for dir in $dir0 $dir1
    do
        test -x "$dir" && eval "$($dir/brew shellenv $SHELL_NAME)" && break
    done
}

homebrew_packages_path_prefix() {
    if test -z "$HOMEBREW_PACKAGES_INSTALL_DIR_PREFIX"; then
        # Cache homebrew install path prefix to avoid (~1s) slowdown when invoking a new shell
        local homebrew_packages_path="$HOMEBREW_PREFIX/opt"
        HOMEBREW_PACKAGES_INSTALL_DIR_PREFIX="$homebrew_packages_path"
    fi
    echo "$HOMEBREW_PACKAGES_INSTALL_DIR_PREFIX"
}

homebrew_package_path_prefix() {
    local packageNameOrRelativePathName="$1"
    echo "$(homebrew_packages_path_prefix)$packageNameOrRelativePathName"
}

homebrew_cask_package_path_prefix() {
    local packageNameOrRelativePathName="$1"
    echo "$(homebrew_packages_path_prefix)/../Caskroom/$packageNameOrRelativePathName"
}

path_prepend() {
    local newPath="$1"
    #echo "PATH: $newPath"
    PATH="$newPath:$PATH"
    export PATH
}

path_append() {
    local newPath="$1"
    #echo "PATH: $newPath:"
    PATH="$PATH:$newPath"
    export PATH
}

manpath_append() {
    local newPath="$1"
    #echo "MANPATH: $newPath:"
    MANPATH="$MANPATH:$newPath"
    export MANPATH
}

manpath_prepend() {
    local newPath="$1"
    #echo "MANPATH: $newPath"
    MANPATH="$newPath:$MANPATH"
    export MANPATH
}

command_exists() {
    command -v $1 >/dev/null 2>&1
}

exec_if_exists() {
    if [[ -x $1 ]]; then
        echo exec $*
        exec $*
    fi
}
