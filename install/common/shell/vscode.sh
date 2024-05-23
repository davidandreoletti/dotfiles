vscode_install_extension() {
    local name="$1"

    vscode="/path/missing/to/code"
    # Find vscode by os path
    #        Fedora          macOS
    for p in "/usr/bin/code" "/usr/local/bin/code"; do
        if command -v "$p"; then
            vscode="$p"
            break
        fi
    done

    $vscode --install-extension "$name"
}
