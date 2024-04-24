# Start mpd daemon for any user to connect to it, if installed
(
    (
        flock --nonblock 9 || exit 0
	if brew services list | grep "mpd" | grep -v "started"; then
		if brew services start mpd; then
			:
		else
			# start mpd in background
			pgrep mpd || mpd "$MPD_CONF_FILE"
		fi
	fi
    ) 9>/tmp/shellrc.mpd.lock >/dev/null &
)
