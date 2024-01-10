function f_weather_by_location() {
    local location="$1"

    lynx --force-secure "wttr.in/$location"
}
