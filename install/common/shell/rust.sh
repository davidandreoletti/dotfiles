cargo_global_install() {
    echo "EXPERIMENTAL: do not use yet"
    exit 1
    cargo=$(which cargo)
    mkdir -p "/usr/local/cargo/bin"
    sudo ${SUDO_OPTIONS} $cargo install --root "/usr/local/cargo/bin" $@
    return $?
}
