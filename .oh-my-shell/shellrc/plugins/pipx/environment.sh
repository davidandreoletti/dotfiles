# pipx installs binary in:
# - macos: 'pipx environment' command output the follow but is slow. Appending paths hardcoded path instead
#          PIPX_BIN_DIR=/Users/davidis/.local/bin
#          PIPX_MAN_DIR=/Users/davidis/.local/share/man
if is_macos || is_linux; then
    path_prepend "$HOME/.local/bin"
    manpath_prepend "$HOME/.local/share/man"
fi
