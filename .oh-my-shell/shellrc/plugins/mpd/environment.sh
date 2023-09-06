MPD_CONF_FILE="$HOME/.mpd/mpd.conf"

# Export MPD host/port for mpd clients to communicate with: mpc, ncmpc, pms
export MPD_PORT=$(command cat $MPD_CONF_FILE | grep "^port" | cut -d\" -f2)
export MPD_HOST=$(command cat $MPD_CONF_FILE | grep "^bind_to_address" | cut -d\" -f2)
