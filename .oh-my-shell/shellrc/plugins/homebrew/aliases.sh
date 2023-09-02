# Update already installed non cask and cask brew packages
alias brewUpgrades="brew update; brew cleanup -s; brew upgrade; brew cask upgrade --greedy --force; brew prune; brew doctor; brew missing"
# List installed homebrew keg-only
alias brewListInstalledKegOnly="brew info --installed --json=v1 | jq 'map(select(.keg_only == true)) | map(.name)'"

