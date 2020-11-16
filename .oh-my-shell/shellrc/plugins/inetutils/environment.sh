# Add GNU inetutils on OSX
# - OSX: brew install coreutils
# FIXME: Check OS === OSX for OSX specific paths
HOMEBREW_INETUTILS_DIR=$(homebrew_package_path_prefix "/inetutils/libexec")
[ -d "$HOMEBREW_INETUTILS_DIR/gnubin" ] && path_prepend "$HOMEBREW_INETUTILS_DIR/gnubin"
[ -d "$HOMEBREW_INETUTILS_DIR/gnuman" ] && manpath_prepend "$HOMEBREW_INETUTILS_DIR/gnuman"
