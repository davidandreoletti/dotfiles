f_run_every_x_seconds() {
    local markerFile="$1"
    local duration="$2"
    if [ -f "$markerFile" ];
    then
        ts1=$(stat -c %Y "$markerFile"); 
        now=$(date '+%s'); 
        ts2=$((now - duration)); 
        if [ "$ts1" -lt "$ts2" ];
        then 
            rm -f "$markerFile" > /dev/null 2>&1;
            return 0
        else
            return 1
        fi
    fi

    return 0
}

f_run_completed() {
    local markerFile="$1"

    touch "$markerFile"
    chmod 777 "$markerFile"
}

f_run_exclusive() {
    local lockFile="$1"
    local logFile="$2"
    #local cmd="${@:3}"

    (
        # why 9 ? reason: https://unix.stackexchange.com/a/475427/45954
        flock --exclusive --nonblock 9;
        #exec > >(tee "$logFile") 2>&1;
        exec "${@:3}";
    ) 9>>"$lockFile"
}

f_run_exclusive_with_completion() {
    local lockFile="$1"
    local logFile="$2"
    local markerFile="$3"
    #local cmd="${@:4}"

    f_run_exclusive "$lockFile" "$logFile" "${@:4}"
    f_run_completed "$markerFile"
}

f_run_exclusive_in_background() {
    local lockFile="$1"
    local logFile="$2"
    #local cmd="${@:3}"

    (
        f_run_exclusive "$lockFile" "$logFile" "${@:3}"
    ) > "$logFile" 2>&1 &
}

f_run_exclusive_in_background_with_completion() {
    local lockFile="$1"
    local logFile="$2"
    local markerFile="$3"
    #local cmd="${@:4}"

    (
        f_run_exclusive "$lockFile" "$logFile" "${@:4}"
        f_run_completed "$markerFile"
    ) > "$logFile" 2>&1 &
}

