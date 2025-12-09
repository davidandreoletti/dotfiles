if command -v nvim; then 
    # sync = install, + clean + update
    command nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1
    # Update mason's registry
    command nvim --headless -c "MasonUpdate" +qa >/dev/null 2>&1
fi
