function f_man_prefer_tldr_when_available() {
    local requested="$1"
    if [ -x "$(command -v tldr)" ]
    then
        command tldr $requested || command man $requested
    else
        command man $requested
    fi
}

function f_man_open_with_mankier() {
    local package_name="$1"

    echo "Opening with your browser: $package_name"
    open "https://www.mankier.com/1/$package_name"
}
