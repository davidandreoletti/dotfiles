if command -v nvim; then 
    # sync = install, + clean + update
    command nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1
    # Update mason's registry
    command nvim --headless -c "MasonUpdate" +qa >/dev/null 2>&1
    # Upgade mason's managed resources
    command nvim --headless -c "autocmd User MasonUpgradeAllComplete sleep 100m | qall" -c 'MasonUpgradeAll'
fi
