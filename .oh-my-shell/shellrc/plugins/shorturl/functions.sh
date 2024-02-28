function f_shorturl_shortenURL() {
    local longURL="$1"
    curl --silent "https://is.gd/create.php?format=simple&url=$longURL"
}

function f_shorturl_shorterurl_to_system_clipboard() {
    local longURL="$1"
    f_shortenURL "$longURL" | tee /dev/tty | ~/.bin/clipboard --to-system
}
