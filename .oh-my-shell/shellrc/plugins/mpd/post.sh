# Start mpd daemon for any user to connect to it, if installed
(
    (
        flock --nonblock 9 || exit 0
        if is_macos || is_linux; then
            # start mpd in background with current user's mpd config
            # "brew services start mpd" fails on macOS
            # "brew services run mpd" fails on macOS
            # "brew services start mpd" unknow on linux
            # "brew services run mpd" unknow on linux
            pgrep mpd || mpd "$MPD_CONF_FILE"
        else
            if brew services list | grep "mpd" | grep -v "started"; then
                if brew services start mpd; then
                    :
                else
                    # start mpd in background
                    pgrep mpd || mpd "$MPD_CONF_FILE"
                fi
            fi
        fi
    ) 9>/tmp/shellrc.mpd.lock >/dev/null &
)
