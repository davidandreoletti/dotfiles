# Add util linux (if installed) 
# on OSX
# - OSX: brew install util-linux
# FIXME: Check OS === OSX for OSX specific paths
HOMEBREW_UTILLINUX_DIR=$(homebrew_package_path_prefix "/util-linux")
[ -d "$HOMEBREW_UTILLINUX_DIR/bin" ] && path_prepend "$HOMEBREW_UTILLINUX_DIR/bin"
[ -d "$HOMEBREW_UTILLINUS_DIR/sbin" ] && path_prepend "$HOMEBREW_UTILLINUX_DIR/sbin"
