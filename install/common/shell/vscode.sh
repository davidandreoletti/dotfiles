vscode_install_extension() {
    local name="$1"

    if command which code; then
        # Find vscode automatically
        vscode="$(command which code)"
    else
        # Find vscode mannually
                 # Fedora         macOS
        for p in "/usr/bin/code"  "/usr/local/bin/code"; do
            if command -v "$p"; then
                vscode = "$p"
                break
            fi
        done
    fi

    $vscode --install-extension "$name"
}
