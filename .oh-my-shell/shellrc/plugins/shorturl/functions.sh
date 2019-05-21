function f_shortenURL() {
    local longURL="$1"
    curl --silent "https://is.gd/create.php?format=simple&url=$longURL"
}

function f_shortenURLAndPasteToSystemClipboard() {
    local longURL="$1"
    f_shortenURL "$longURL" | tee /dev/tty | pbcopy
}
