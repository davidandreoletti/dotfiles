# Load Bash/ZSH completion in the current shell
if command -v kubectl >/dev/null 2>&1; then
    shellNameLowercase=$(basename $SHELL | tr '[:upper:]' '[:lower:]')
    . <(kubectl completion $shellNameLowercase)
fi

