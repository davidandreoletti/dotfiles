f_dns_clear_cache() {
    if is_macos; then
        # only: monterey/ventura
        sudo killall -HUP mDNSResponder || sudo killall mDNSResponderHelper
        sudo dscacheutil -flushcache
    elif is_linux; then
        # src: https://superuser.com/a/1183819/47829
        if test "$(ps --no-headers -o comm 1)" = "systemd"; then
            sudo systemd-resolve --flush-caches
        else
            echo "ERROR: systemd not supported. dns cache not cleared"
        fi
    else
        echo "ERROR: clearing dns cache not supported on this system"
    fi
}
