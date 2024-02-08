if command_exists volta; then
     volta completions --force --output "$SHELLRC_COMPLETION_USER_DIR/_volta" $SHELL_NAME 1>/dev/null 2>&1 # silent
fi
