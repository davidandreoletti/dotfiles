# NVM offficial documentation setup (as reported by brew install nvm)
mkdir -p ${HOME}/.nvm > /dev/null 2>&1
export NVM_DIR="${HOME}/.nvm"

# Load nvm shell functions
# - ignoring desactivated nvm error due to:
#  - nvm is not compatible with the npm config "prefix" option: currently set to "${HOME}/.npm"
#  - Run `npm config delete prefix` or `nvm use --delete-prefix v8.11.4 --silent` to unset it.
HOMEBREW_NVM_SCRIPT=$(homebrew_package_path_prefix "/nvm/nvm.sh")
dot_if_exists "$HOMEBREW_NVM_SCRIPT" 
