# Load Bash/ZSH completion in the current shell
if command -v kubectl >/dev/null 2>&1; then
    . <(kubectl completion $SHELL_NAME)
fi

