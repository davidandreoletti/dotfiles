export MPD_CONF_DIR="$HOME/.config/mpd"
export MPD_COMMON_CONF_FILE="$MPD_CONF_DIR/common.conf"
if is_linux; then
    export MPD_CONF_FILE="$MPD_CONF_DIR/mpd_linux.conf"
elif is_macos; then
    export MPD_CONF_FILE="$MPD_CONF_DIR/mpd_macos.conf"
else
    export MPD_CONF_FILE="$MPD_CONF_DIR/mpd_missing.conf"
fi

# Export MPD host/port for mpd clients to communicate with: mpc, ncmpc, pms
export MPD_PORT=$(command cat $MPD_COMMON_CONF_FILE | grep "^port" | cut -d\" -f2)
export MPD_HOST=$(command cat $MPD_COMMON_CONF_FILE | grep "^bind_to_address" | cut -d\" -f2)
