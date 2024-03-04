###############################################################################
# Message related functions
###############################################################################

_message_show() {
    local severity="$1"
    local message="$2"

    local color_start=""
    local color_end=""

    case "$severity" in
        "ERROR") 
            color_start="\033[31;1m"
            color_end="\033[30;1m"
            ;;
        "WARNING") 
            color_start="\033[33;1m"
            color_end="\033[0m"
            ;;
        "INFO") 
            color_start="\033[34;1m"
            color_end="\033[0m"
            ;;
        "TEST") 
            color_start="\033[0;36m"
            color_end="\033[0m"
            ;;
        *)
            ;;
    esac
    printf "${color_start}${severity}: ${message}${color_end}\n"
    return 0
}

#param1: message
message_info_show() {
    _message_show "INFO" "$1"
}

#param1: message
message_error_show() {
    _message_show "ERROR" "$1"
}

#param1: message
message_warning_show() {
    _message_show "WARNING" "$1"
}

#param1: message
message_test_show() {
    _message_show "TEST" "$1"
}
