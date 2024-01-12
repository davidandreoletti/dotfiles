function f_man_prefer_alternative() {
    local program="$1"
    if command_exists cheat ;
    then
        cat <(echo "--tldr: $program ---------------------------------------") \
            <(command tldr $program) \
            <(echo "--cheat: $program ---------------------------------------") \
            <(command cheat $program)
    else
        command man $program
    fi
}

function f_man_open_with_mankier() {
    local package_name="$1"

    echo "Opening with your browser: $package_name"
    open "https://www.mankier.com/1/$package_name"
}
