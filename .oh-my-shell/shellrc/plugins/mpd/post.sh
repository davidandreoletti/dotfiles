# Start mpd daemon for any user to connect to it, if installed
(
    flock --nonblock 9 || exit 0
    brew services list | grep "mpd" | grep -v "started" && brew services start mpd
) 9>/tmp/shellrc.mpd.lock > /dev/null & 
