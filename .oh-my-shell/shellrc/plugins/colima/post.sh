if command_exists 'colima'; then
    colima completion $SHELL_NAME >"$SHELLRC_COMPLETION_USER_DIR/_colima" 1>/dev/null 2>&1 # silent
fi
