# NVM offficial documentation setup (as reported by brew install nvm)
mkdir -p ${HOME}/.nvm > /dev/null 2>&1
export NVM_DIR="${HOME}/.nvm"

function loadNVMSlow() {
    # Load nvm shell functions the official way but slow
    # - ignoring desactivated nvm error due to:
    #  - nvm is not compatible with the npm config "prefix" option: currently set to "${HOME}/.npm"
    #  - Run `npm config delete prefix` or `nvm use --delete-prefix v8.11.4 --silent` to unset it.
    HOMEBREW_NVM_SCRIPT=$(homebrew_package_path_prefix "/nvm/nvm.sh")
    dot_if_exists "$HOMEBREW_NVM_SCRIPT" 
}

function loadNVMFast() {
    # Load nvm shell functions fast. 
    # src: https://www.growingwiththeweb.com/2018/01/slow-nvm-init.html
    # - Assumes:
    #   -- NVM was installed from Homebrew
    #   -- nvm `default` alias set. 
    # - Why ? 
    #   -- Avoids doing slow sanity checks.
    # - Caveats:
    #   -- No check means NVM may end up failing or not working without a clear error message
    HOMEBREW_NVM_SCRIPT=$(homebrew_package_path_prefix "/nvm/nvm.sh")
    source "$HOMEBREW_NVM_SCRIPT" --no-use
    NODE_VERSION=$(cat $NVM_DIR/alias/default)
    path_prepend "$NVM_DIR/versions/node/v$NODE_VERSION/bin"
}

loadNVMFast &> /dev/null

