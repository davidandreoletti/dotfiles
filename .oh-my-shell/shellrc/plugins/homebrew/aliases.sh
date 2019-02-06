# Update already installed non cask and cask brew packages
alias brewUpgrades="brew update; brew cleanup -s; brew upgrade; brew cask upgrade --greedy --force; brew prune; brew doctor; brew missing"

