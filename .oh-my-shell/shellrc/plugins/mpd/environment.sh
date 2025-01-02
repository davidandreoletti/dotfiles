if is_linux;
then
    export MPD_CONF_FILE="$HOME/.config/mpd/mpd_linux.conf"
elif is_macos;
then
    export MPD_CONF_FILE="$HOME/.config/mpd/mpd_macos.conf"
else
    export MPD_CONF_FILE="$HOME/.config/mpd/mpd_missing.conf"
fi

# Export MPD host/port for mpd clients to communicate with: mpc, ncmpc, pms
export MPD_PORT=$(command cat $MPD_CONF_FILE | grep "^port" | cut -d\" -f2)
export MPD_HOST=$(command cat $MPD_CONF_FILE | grep "^bind_to_address" | cut -d\" -f2)
