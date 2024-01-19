TLDR_POST_BASE="$HOME/.oh-my-shell/tmp/tldr_post"
TLDR_POST_MARKER="${TLDR_POST_BASE}.marker"

# 3600*24*7 = 7 days
if f_run_every_x_seconds "$TLDR_POST_MARKER" "$((3600 * 24 * 7))"; then

    # Always update the local database
    TLDR_INSTALL_SCRIPT="${TLDR_POST_BASE}.install.sh"
    TLDR_INSTALL_LOG="${TLDR_INSTALL_SCRIPT}.log"

    cat <<EOF >"$TLDR_INSTALL_SCRIPT"
    tldr --update
EOF

    f_run_exclusive_in_background_with_completion "${TLDR_INSTALL_SCRIPT}.lockfile" "$TLDR_INSTALL_LOG" "$TLDR_POST_MARKER" bash $TLDR_INSTALL_SCRIPT
fi
