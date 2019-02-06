# Load Bash/ZSH completion in the current shell
if command -v npm >/dev/null 2>&1; then
    . <(npm completion)
fi
