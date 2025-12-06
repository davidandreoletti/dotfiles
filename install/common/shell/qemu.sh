qemu_is_running() {
    if grep -qi "QEMU" /sys/class/dmi/id/product_name; then
        return 0
    elif grep -qi "QEMU" /proc/cpuinfo; then
        return 0
    elif command -v virt-what >/dev/null && [[ $(virt-what) == "qemu" ]]; then
        return 0
    else
        return 1
    fi
}
