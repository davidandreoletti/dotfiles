if command_exists gh; then
     gh completion --shell $SHELL_NAME > "$SHELLRC_COMPLETION_USER_DIR/_gh" 1>/dev/null 2>&1 # silent
fi
