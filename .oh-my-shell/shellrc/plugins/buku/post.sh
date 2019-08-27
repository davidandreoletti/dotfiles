# Use db stored on dropbox
DROPBOX_BUKU_DB_FILE="$DROPBOX_PERSONAL_DIR/Apps/Buku/bookmarks.db"
[ "$(readlink -f \"$DROPBOX_BUKU_DB_FILE\")" = "$BUKU_DB_FILE" ] || ln -s $DROPBOX_BUKU_DB_FILE "$BUKU_DB_FILE" > /dev/null 2>&1
