# Default db path.
# DO NOT CHANGE IT
# src: https://github.com/jarun/Buku/wiki/Operational-notes#general
export BUKU_DB_FILE="$HOME/.local/share/buku/bookmarks.db"

#Buku configuration only available as environment variables
export BUKU_SERVER_PORT="63010"
export BUKU_SERVER_HOST="127.0.0.1"
export BUKU_SERVER_DB_FILE="$BUKU_DB_FILE"
export BUKU_SERVER_PER_PAGE=99999
export BUKU_SERVER_DISABLE_FAVICON="false"
export BUKU_SERVER_OPEN_IN_NEW_TAB="false"
export BUKU_SERVER_URL_RENDER_MODE="full"
export BUKU_SERVER_SECRET_KEY=""
