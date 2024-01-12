# Add GNU which (if installed) to have access to which --skip-alias / --skip-functions since bash/zsh's which builtin is very limited
# gnu-which tools (eg: which) to be prefixed with g (eg: gwhich) on OSX
# - OSX: brew install gnu-which
HOMEBREW_GNUWHICH_DIR=$(homebrew_package_path_prefix "/gnu-which/libexec")
[ -d "$HOMEBREW_GNUWHICH_DIR/gnubin" ] && path_prepend "$HOMEBREW_GNUWHICH_DIR/gnubin"
[ -d "$HOMEBREW_GNUWHICH_DIR/gnuman" ] && manpath_prepend "$HOMEBREW_GNUWHICH_DIR/gnuman"
