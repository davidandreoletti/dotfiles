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

homebrew_packages_path_prefix() {
    if test -z "$HOMEBREW_PACKAGES_INSTALL_DIR_PREFIX"
    then 
        # Cache homebrew install path prefix to avoid (~1s) slowdown when invoking a new shell
        # FIXME: return /homebrew/not/installed
        local homebrew_packages_path="$(brew --prefix)/opt"
        export HOMEBREW_PACKAGES_INSTALL_DIR_PREFIX="$homebrew_packages_path"
    fi
    echo "$HOMEBREW_PACKAGES_INSTALL_DIR_PREFIX"
}

homebrew_package_path_prefix() {
    local packageNameOrRelativePathName="$1"
    local homebrew_package_path="$(homebrew_packages_path_prefix)$packageNameOrRelativePathName"
    echo "$homebrew_package_path"
}

# Execute commands in listed files, in the current environment
# Usage: dot "file1.sh" "file2.sh"
dot() {
  for f in $*
  do
      #echo source $(basename $f)
      . $f
  done
}

# Execute commands in listed files, in the current environment, for files that exist
# Usage: dot_if_exists "file1.sh" "file2.sh"
dot_if_exists() {
    for f in $*
    do
        if [ -f $f ] && [ -r $f ]
        then
            #echo source $(basename $f)
            . $f
        fi
    done
}

# Execute commands in listed files, in the current environment, for the very first file that exist
# Usage: dot_if_exists "file1.sh" "file2.sh"
dot_first_if_exists() {
    for f in $*
    do
        if [ -f $f ] && [ -r $f ]
        then
            #echo source $f
            . $f
            return
        fi
    done
}

append_path() {
    #echo "PATH+ '$2'"
    PATH="${PATH}:$1"
    export PATH
}
