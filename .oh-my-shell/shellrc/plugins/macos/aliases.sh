# FIXME: Automated this: https://rderik.com/blog/tracking-where-settings-are-stored-on-macos/
alias tracking_preferences_changes="sudo fs_usage -f filesys | grep plist | grep cfprefsd"
