# Initialize rustup-init if never done before
if test -d "$HOME/.rustup/toolchains"; then
    # rustup is updated via homebrew
    # NO need for 'rustup self update'
    :

    # Update toolchains
    rustup update 1>/dev/null 2>&1 # silence updates
else
    rustup-init -y --verbose

    # Install toolchains 
    for name in stable beta nightly
    do
        rustup toolchain install $name 1>/dev/null 2>&1 
    done
fi
