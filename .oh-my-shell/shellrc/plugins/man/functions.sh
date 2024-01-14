function f_man_open_with_mankier() {
    local package_name="$1"

    echo "Opening with your browser: $package_name"
    open "https://www.mankier.com/1/$package_name"
}
