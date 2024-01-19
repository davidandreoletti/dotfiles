function f_bukuserver_run() {
    # Run singelton server
    if ! pgrep -f "bukuserver"; then
        bukuserver run --host $BUKU_SERVER_HOST --port $BUKU_SERVER_PORT
        sleep 2s
    fi
}

function f_buku_open_bookmark_browser() {
    (sleep 2s && open "http://$BUKU_SERVER_HOST:$BUKU_SERVER_PORT") &
    f_bukuserver_run
}
