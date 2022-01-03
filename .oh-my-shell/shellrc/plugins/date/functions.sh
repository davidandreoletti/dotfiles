f_timestampToDates () {
    timestamp="$1"

    echo "Current device's timezone: "
    date --iso-8601 --date="@$timestamp"

    echo "UTC timezone: "
    date --iso-8601 --utc --date="@$timestamp"
}
