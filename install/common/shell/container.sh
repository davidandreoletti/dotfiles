container_is_running() {
    if test -f /.dockerenv; then
        # ubuntu 20.04+
        return 0
    elif test -e /bin/running-in_container; then
        # Ubuntu 20.04+ support
        if /bin/running-in_container; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}
