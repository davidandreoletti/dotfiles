###############################################################################
# RAM disk related functions
###############################################################################

export CURRENT_MOUNT_DIR="none"

# param1: ramdiskname
# default: 128Mb storage
# storage mounted at /Volume/ramdiskname
ramdisk_create_and_mount_storage() {
    local name="$1"
    local mount_path="$HOME/$name"

    sudo mkdir -p "$mount_path"
    sudo ls -alh "$mount_path"
    sudo mount -t tmpfs -o size=128M,uid=$(id -u),gid=$(id -g),mode=700 "$name" "$mount_path"

    export CURRENT_MOUNT_DIR="$mount_path"
}

ramdisk_umount_and_destroy_storage() {
    sudo umount "$CURRENT_MOUNT_DIR"
    sudo rm -rf "$CURRENT_MOUNT_DIR"

    export CURRENT_MOUNT_DIR="none"
}
