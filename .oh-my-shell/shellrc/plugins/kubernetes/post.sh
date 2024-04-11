# Load Bash/ZSH completion in the current shell
command_exists 'kubectl' && kubectl completion $SHELL_NAME >"$SHELLRC_COMPLETION_USER_DIR/_kubectl"
