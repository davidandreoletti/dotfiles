if is_macos; then
    alias mdns_browse='dns-sd -B'
elif is_linux; then
    alias mdns_browse='avahi-browse --all'
fi
