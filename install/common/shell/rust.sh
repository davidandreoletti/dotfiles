cargo_global_install() {
    echo "EXPERIMENTAL: use at your own risk"
    cargo=$(which cargo)
    mkdir -p "/usr/local/cargo/bin"
    sudo ${SUDO_OPTIONS} $cargo install --root "/usr/local/cargo/bin" $@
    return $?
}
