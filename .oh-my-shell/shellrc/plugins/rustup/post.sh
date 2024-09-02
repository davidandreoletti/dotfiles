# Initialize rustup-init if never done before
if test -d "$HOME/.rustup/toolchains"; then
    # rustup is updated via homebrew
    # NO need for 'rustup self update'
    :

    # Install/Update toolchains without updating rustup itself
    for name in stable beta nightly; do
        rustup toolchain install --no-self-update $name 1>/dev/null 2>&1
    done
else
    # Install/update default toolchain
    rustup-init -y --verbose
fi
