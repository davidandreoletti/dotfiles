# Generate shell completion
command_exists uv && uv generate-shell-completion $SHELL_NAME >"$SHELLRC_COMPLETION_USER_DIR/_uv"
