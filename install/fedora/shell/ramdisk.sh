###############################################################################
# RAM disk related functions
###############################################################################

export CURRENT_RAM_DISK="none"

# param1: ramdiskname
# default: 128Mb storage
# storage mounted at /Volume/ramdiskname
ramdisk_create_and_mount_storage() {
    local name="$1"
    local mount_path="$HOME/$name"

    mkdir -p "$mount_path"
    sudo mount -t tmpfs -o size=128M,uid=$(id -u),gid=$(id -g),mode=700 "$name" "$mount_path"

    export CURRENT_RAM_DISK="$mount_path"
}

ramdisk_umount_and_destroy_storage() {
    sudo umount "$CURRENT_RAM_DISK"
    sudo rm -rf "$CURRENT_RAM_DISK"

    export CURRENT_RAM_DISK="none"
}
