###############################################################################
# RAM disk related functions
###############################################################################

export CURRENT_RAM_DISK="none"

# param1: ramdiskname
# default: 128Mb storage
# storage mounted at /Volume/ramdiskname
ramdisk_create_and_mount_storage() {
    export CURRENT_RAM_DISK=`hdiutil attach -nomount ram://128000 | tr -d '\040\011\012\015'`
    diskutil erasevolume HFS+ "$1" "$CURRENT_RAM_DISK" 
}

ramdisk_umount_and_destroy_storage() {
    umount "$CURRENT_RAM_DISK"
    hdiutil detach "$CURRENT_RAM_DISK"
    export CURRENT_RAM_DISK="none"
}
