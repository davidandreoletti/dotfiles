# Add GNU coretutils (if installed) to have dircolors and prevent all
# coretutils tools (eg: dircolors) to be prefixed with g (eg: gdircolors)
# on OSX
# - OSX: brew install coreutils
# FIXME: Check OS === OSX for OSX specific paths
HOMEBREW_GNUCOREUTILS_DIR=$(homebrew_package_path_prefix "/coreutils/libexec")
[ -d "$HOMEBREW_GNUCOREUTILS_DIR/gnubin" ] && path_prepend "$HOMEBREW_GNUCOREUTILS_DIR/gnubin:$PATH"
[ -d "$HOMEBREW_GNUCOREUTILS_DIR/gnuman" ] && path_prepend "$HOMEBREW_GNUCOREUTILS_DIR/gnuman:$MANPATH"
