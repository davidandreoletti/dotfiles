###############################################################################
# Message related functions
###############################################################################

_message_show() {
    echo "$1"
    return 0
}

#param1: message
message_info_show() {
    _message_show "INFO:$1"
}

#param1: message
message_error_show() {
    _message_show "ERROR:$1"
}

#param1: message
message_warning_show() {
    _message_show "WARNING:$1"
}


#param1: message
message_test_show() {
    _message_show "TEST:$1"
}
