# Generate shell completion
if command_exists uv;
then
    uv generate-shell-completion $SHELL_NAME
fi
