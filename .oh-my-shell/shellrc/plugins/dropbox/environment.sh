# src: https://help.dropbox.com/installs-integrations/desktop/locate-dropbox-folder#programmatically
DROPBOX_INFO_FILE="$HOME/.dropbox/info.json"

export DROPBOX_PERSONAL_DIR="$(jq -r ".personal.path" $DROPBOX_INFO_FILE)"
export DROPBOX_WORK_DIR="$(jq -r ".business.path" $DROPBOX_INFO_FILE)"

