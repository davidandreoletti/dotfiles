function f_usbip_start_client_connect() {
    local server_ip="$1"

    echo "Available USB devices on $server_ip"
    usbip list -r "$server_ip"

    echo "Which device to bind (eg: 1-1.5) ?"
    local dev="$2"
    read dev

    echo "Binding to $dev"
    sudo usbip attach -r "$server_ip" -b "$dev"
}

function f_usbip_start_client_disconnect() {
    echo "Available USB devices to disconnect"
    usbip port

    echo "Select port to disconnect"
    read port

    echo "Unbinding $port locally"
    usbip detach -p "$port"

    echo "Unbind device remotely"
    read busid
    usbip unbind -b "$busid"
}

function f_usbip_start_server() {
    if is_macos; then
        git clone git@github.com:jiegec/usbip.git usbip.git
        cd usbip.git
        echo "Offering all usb devices"
        env RUST_LOG=info cargo run --example host
        cd -
    if is_linux; then
        # List usb devices
        usbip list -l
        echo "Which device to bind (eg: 1-1.5) ?"
        read dev
        echo "Binding $dev"
        usbip bind -b "$dev"
        echo "Press any key to unbind $dev"
        read
        usbip unbind -b "$dev"
    else
        echo "ERROR: USB/IP server support missing."
    fi
}
