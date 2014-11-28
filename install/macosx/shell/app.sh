###############################################################################
# App related functions
###############################################################################

MACOSX_APPLICATION_DIR="/Applications"
CURL_RETRY_OPTION=3

# param1: name
# param2: url
app_download_install() {
    pushd /tmp
    curl --retry $CURL_RETRY_OPTION -o "$1" -L "$2" && unzip "$1" -d $MACOSX_APPLICATION_DIR
    popd
}

app_pkg_download_install() {
    :
    # FIXME 
    # /usr/bin/curl --retry $curl_retry_option -o /tmp/mactex.pkg -L \"$app_url_mactex\"; sudo installer -allowUntrusted -pkg /tmp/mactex.pkg -target /",
}
