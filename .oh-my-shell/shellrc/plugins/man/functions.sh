function f_man_prefer_tldr_when_available() {
    local requested="$1"
    if [ -x "$(command -v tldr)" ]
    then
        command tldr $requested || command man $requested
    else
        command man $requested
    fi
}
