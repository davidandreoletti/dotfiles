# Update already installed non cask and cask brew packages
# Usage: brew_upgrade_packages 
alias brew_upgrade_packages="brew update; brew cleanup -s; brew upgrade; brew cask upgrade --greedy --force; brew prune; brew doctor; brew missing"

# List installed homebrew keg-only
# Usage: brew_list_installed_packages_kegonly 
alias brew_list_installed_packages_kegonly="brew info --installed --json=v1 | jq 'map(select(.keg_only == true)) | map(.name)'"

# List all brews installed 
# Usage: brew_list_installed_packages
alias brew_list_installed_packages="brew list; brew list --cask"

# Show package info
# Usage: brew_package_info "virt-manager"
alias brew_package_info="brew info "

# Install package interractively
# Usage: brew_install "foobar"
alias brew_install_package="f_homebrew_bip "

# Uninstall package interractively
# Usage: brew_uninstall_package "foobar"
alias brew_uninstall_package="f_homebrew_bcp"

# Update package interractively
# Usage: brew_update_package "foobar"
alias brew_uninstall_package="f_homebrew_bup"

# Download homebrew core in the current directory, move to PACKAGE dir, open a shell to write a fix
# Usage: homebrew_core_fix_package PACKAGE 
alias homebrew_core_fix_package="f_homebrew_core_fix_package "
