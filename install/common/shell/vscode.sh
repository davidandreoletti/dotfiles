vscode_install_extension() {
    local name="$1"

    vscode="$(command which code)"
    $vscode --install-extension "$name"
}
