# Add GNU libiconv (if installed) to newer iconv version
# - OSX: brew install libiconv
# FIXME: Check OS === OSX for OSX specific paths
HOMEBREW_LIBICONV_DIR=$(homebrew_package_path_prefix "/libiconv")
[ -d "$HOMEBREW_LIBICONV_DIR/bin" ] && path_prepend "$HOMEBREW_LIBICONV_DIR/bin:$PATH"
