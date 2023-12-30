f_dns_clear_cache () {
    # macOS only
    sudo killall -HUP mDNSResponder || sudo killall mDNSResponderHelper; sudo dscacheutil -flushcache
}
