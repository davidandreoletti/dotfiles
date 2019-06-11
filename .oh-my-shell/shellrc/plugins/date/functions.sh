f_timestampToDates () {
    timestamp="$1"

    echo "Current device's timezone: "
    date --rfc-2822 -d @$timestamp 

    echo "UTC timezone: "
    date --rfc-2822 --utc -d @$timestamp 
}
