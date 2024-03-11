###############################################################################
# RAM disk related functions
###############################################################################

export CURRENT_DEVICE="none"
export CURRENT_MOUNT_DIR="none"

# param1: ramdiskname
# default: 128Mb storage
# storage mounted at /Volume/ramdiskname
ramdisk_create_and_mount_storage() {
    local name="$1"

    export CURRENT_DEVICE=`hdiutil attach -nomount ram://128000 | tr -d '\040\011\012\015'`
    diskutil erasevolume HFS+ "$name" "$CURRENT_DEVICE"
    export CURRENT_MOUNT_DIR="/Volumes/$name"
}

ramdisk_umount_and_destroy_storage() {
    umount "$CURRENT_MOUNT_DIR"
    hdiutil detach "$CURRENT_DEVICE"
    export CURRENT_MOUNT_DIR="none"
    export CURRENT_DEVICE="none"
}
