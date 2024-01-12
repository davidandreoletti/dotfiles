# Add gnu-sed (if installed) to haveGNU sed
# gnu-sed tools (eg: dircolors) to be prefixed with g (eg: gsed)
# on OSX
# - OSX: brew install gnu-sed
HOMEBREW_GNUSED_DIR=$(homebrew_package_path_prefix "/gnu-sed/libexec")
[ -d "$HOMEBREW_GNUSED_DIR/gnubin" ] && path_prepend "$HOMEBREW_GNUSED_DIR/gnubin"
[ -d "$HOMEBREW_GNUSED_DIR/gnuman" ] && manpath_prepend "$HOMEBREW_GNUSED_DIR/gnuman"
