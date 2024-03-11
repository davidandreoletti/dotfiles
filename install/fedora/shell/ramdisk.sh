###############################################################################
# RAM disk related functions
###############################################################################

export CURRENT_MOUNT_DIR="none"

# param1: ramdiskname
# default: 128Mb storage
# storage mounted at /Volume/ramdiskname
ramdisk_create_and_mount_storage() {
    local name="$1"

    uid=$(sudo id -u)
    gid=$(sudo id -g)

    if test $uid -eq 0; then
        # Github CI test case only
        local mount_path="/tmp/$name"
    else
        local mount_path="$HOME/$name"
    fi

    mkdir -p "$mount_path"
    if sudo mount -t tmpfs -o size=128M,uid=$uid,gid=$gid,mode=700 "$name" "$mount_path"; then
        :
    else
        dmesg
        exit 1
    fi

    export CURRENT_MOUNT_DIR="$mount_path"
}

ramdisk_umount_and_destroy_storage() {
    sudo umount "$CURRENT_MOUNT_DIR"
    sudo rm -rf "$CURRENT_MOUNT_DIR"

    export CURRENT_MOUNT_DIR="none"
}
