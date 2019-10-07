# Add GNU findutils (if installed) to have xargs and prevent all
# coretutils tools (eg: dircolors) to be prefixed with g (eg: gdircolors)
# on OSX
# - OSX: brew install coreutils
# FIXME: Check OS === OSX for OSX specific paths
HOMEBREW_GNUFINDUTILS_DIR=$(homebrew_package_path_prefix "/findutils/libexec")
[ -d "$HOMEBREW_GNUFINDUTILS_DIR/gnubin" ] && path_prepend "$HOMEBREW_GNUFINDUTILS_DIR/gnubin"
[ -d "$HOMEBREW_GNUFINDUTILS_DIR/gnuman" ] && manpath_prepend "$HOMEBREW_GNUFINDUTILS_DIR/gnuman"
