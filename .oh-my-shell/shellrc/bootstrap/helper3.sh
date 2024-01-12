f_file_modified_date_recently_within() {
    :    
}

f_file_touch_modified_date() {
    :
}

# Create a ram backed mount point with the specific size (in mb)
# Usage: function 10 "/Volumes/baz"
f_create_ramfs() {
    local sizeinMegabytes=${1:-10} # APFS: 10mb disk minimun
    local uid=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10 | grep --invert-match "%")
    local mountPoint="${2:-/Volumes/ramdisk-$uid}"
    local blocksize=$(echo "$sizeinMegabytes * 2048" | bc)
    local device="$(hdiutil attach -nomount "ram://$blocksize" | cut -f1 -d$'\t' | tr -d ' ')"

    if is_macos ; 
    then
        # src: https://stackoverflow.com/a/47354885/219728
        # Create RAM disk + Mount point onto RAM disk
        diskutil partitionDisk $device 1 GPTFormat APFS "$(basename $mountPoint)" '100%' > /dev/null 2>&1
        echo "$mountPoint"
    else
        echo "f_delete_ramfs unsupported on $OS_TYPE"
    fi
}

# Unmount a ram backed mount point
f_delete_ramfs() {
    local mountPoint="$1"

    if is_macos ; 
    then
        local device="$(mount | grep "$mountPoint" | cut -f1 -d' ')"
        device="/dev/$(diskutil info /dev/disk5 | grep "APFS Physical Store" | cut -f13 -d' ')"
        # Unmount RAM disk + Release RAM disk
        diskutil eject "$device" > /dev/null 2>&1
    else
        echo "f_delete_ramfs unsupported on $OS_TYPE"
    fi
}
