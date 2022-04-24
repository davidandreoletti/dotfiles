FIREFOX_BIN="/Applications/Firefox.app/Contents/MacOS/firefox-bin"

[ ! -f "$FIREFOX_BIN" ] && echo "Firefox not installed. Skipping extensions intallation." && exit 0

echo "Firefox browser will open multiple window, each asking to install a different add-ons"
echo "Once all add-ons install, kill the firefox browser instance to resume the installation"
$FIREFOX_BIN --browser \
    --new-tab "https://addons.mozilla.org/firefox/downloads/file/1668522/tridactyl-1.14.8-an+fx.xpi"
    --new-tab "https://addons.mozilla.org/firefox/downloads/file/1209034/react_developer_tools-3.6.0-fx.xpi"

# FIXME: Later, download add ons version, automatically from selenium
## https://stackoverflow.com/a/28031137/219728
