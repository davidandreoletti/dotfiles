systemd_systemctl_enable() {
    local unit="$1"

    if container_is_running; then
        # no systemd on containers
        :
    else
        sudo systemctl enable $unit
    fi
}

systemd_systemctl_start() {
    local unit="$1"

    if container_is_running; then
        # no systemd on containers
        :
    else
        sudo systemctl start $unit
    fi
}
