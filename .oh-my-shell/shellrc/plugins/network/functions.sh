f_http_show_in_out_traffic() {
    local interfaces=${1:-"any"}
    local port=${2:-"80"}
    local verbs=${3:-"GET|POST|PUT|PATCH|DELETE"}
    echo "Listening to HTTP traffic from/to port $port on interface(s) $interfaces"

    sudo ngrep -d $interfaces -t "^($verbs)" "tcp and port $port"
}

f_http_show_in_out_traffic2() {
    local interfaces=${1:-"all"}
    local port=${2:-"80"}
    local verbs=${3:-"GET|POST|PUT|PATCH|DELETE"}
    echo "Listening to HTTP traffic from/to port $port on interface(s) $interfaces"

    sudo tcpdump -i "$interfaces" -n -s 0 -w - "tcp port $port" | grep -a -o -E \"Host\: .* | $verbs \/.*\"
}

# Get http headers
f_http_headers() {
    /usr/bin/curl -I -L $@
}
