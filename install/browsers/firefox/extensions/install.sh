# FIXME: https://askubuntu.com/questions/73474/how-to-install-firefox-addon-from-command-line-in-scripts
#
FIREFOX_BIN="/Applications/Firefox.app/Contents/MacOS/firefox"

if [ ! -f "$FIREFOX_BIN" ]; then
    echo "Firefox not installed. Skipping extensions intallation."
else
    echo "Firefox browser will open multiple window, each asking to install a different add-ons"
    echo "Once all add-ons install, kill the firefox browser instance to resume the installation"
    $FIREFOX_BIN --browser \
        --new-tab "https://addons.mozilla.org/en-US/firefox/addon/vimium-ff" \
        --new-tab "https://google.com"
    # FIXME: Later, download add ons version, automatically from selenium
    ## https://stackoverflow.com/a/28031137/219728
fi
