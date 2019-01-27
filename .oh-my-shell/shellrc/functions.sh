#
# Get os type
#
get_os_type() {
    case "$OSTYPE" in
        darwin*)  echo "macosx" ;;
        linux*)   echo "linux" ;;
        *)        echo "unknown" ;;
    esac
}

# Get shell name
get_shell_type() {
    if [ -n "$BASH_VERSION" ]; then
        echo "bash"
    elif test -n "$ZSH_VERSION" ; then
        echo "zsh"
    else
        echo "unknow-shell"
    fi
}
