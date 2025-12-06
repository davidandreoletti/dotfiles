cargo_install() {
    echo "EXPERIMENTAL: use at your own risk"
    cargo=$(which cargo)
    CARGO_USER_BIN_DIR="$HOME/.cargo/bin"
    mkdir -p "$CARGO_USER_BIN_DIR"
    sudo ${SUDO_OPTIONS} $cargo install --root "$CARGO_USER_BIN_DIR" $@
    return $?
}
