if command -v "rustup"; then
    # Set default toolchain
    rustup default stable 1>/dev/null 2>&1 # silence
fi
