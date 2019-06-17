function forceUserToInstallExtensions() {
    PER_USER_CHROME_EXTENSIONS_DIR_PATH="$HOME/Library/Application Support/Google/Chrome/External Extensions/"
    mkdir -pv "$PER_USER_CHROME_EXTENSIONS_DIR_PATH"

    for f in $(find . -type f -name "*.json");
    do
        echo "Installing $f to $PER_USER_CHROME_EXTENSIONS_DIR_PATH"
        cp -v "$f" "$PER_USER_CHROME_EXTENSIONS_DIR_PATH/"
    done
}

function promptUserToInstallExtensions() {
    #
    # Get all extensions to install
    #
    EXTENSIONS_FILE_PATH="/tmp/$USER-chrome-extensions.txt"
    rm -fv "$EXTENSIONS_FILE_PATH"

    for f in $(find . -type f -name "*.json");
    do
        filename=$(basename "$f")
        extensionID="${filename%.*}"
        echo "$extensionID" >> "$EXTENSIONS_FILE_PATH"
    done


    #
    # Geneate page with extensions to install
    #
    PAGE_HTML_FILE_PATH="/tmp/$USER-chrome-extensons-install.html"

cat <<EOF > "$PAGE_HTML_FILE_PATH"
<html>
<head>
    <title>Chrome Extensions Installation</title>
</head>
<body>
    <h1>Install each plugin manually.</h1>
<ul>
EOF

cat "$EXTENSIONS_FILE_PATH" | xargs -n1 -I % echo "<li><a rel=\"chrome-webstore-item\" href=\"https://chrome.google.com/webstore/detail/%\">Install extension %</a></li>" >> "$PAGE_HTML_FILE_PATH"

cat <<EOF >> "$PAGE_HTML_FILE_PATH"
</ul>
</body>
</html>
EOF

    #
    # Open page on chrome for user to install extensions manually :-(
    # 
    open -a "Google Chrome" $PAGE_HTML_FILE_PATH
}

promptUserToInstallExtensions
