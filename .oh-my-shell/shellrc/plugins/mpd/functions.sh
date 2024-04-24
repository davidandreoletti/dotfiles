f_mpd_start_server_for_player() {
    local client="$1"
    pgrep mpd || mpd "$MPD_CONF_FILE"
    eval $client
}
