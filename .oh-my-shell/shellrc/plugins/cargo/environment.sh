# Per user binaries
export CARGO_HOME="$HOME/.cargo"

path_prepend "$CARGO_HOME/bin"

# EXPERIMENTAL
# Per system binaries
#[ -d "/usr/local/cargo/bin" ] && path_prepend "/usr/local/cargo/bin"
