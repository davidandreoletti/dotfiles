###############################################################################
# Filesystem related functions
###############################################################################

# param1: absolute volume path
fs_has_volume() {
    [ -d "$1" ] && return 0
    return 1
}

fs_copy() {
    cp -rfv $@
}

MACOSX_SYSTEM_LAUNCH_DAEMON_DIR="/Library/LaunchDaemons"

#fs_enable_noatime_flag_on_boot_filesystem() {
    #local plistname="com.davidandreoletti.ssd.plist"
    #local plist=`install_file_get_fullpath "$plistname"`
    #pushd "$MACOSX_SYSTEM_LAUNCH_DAEMON_DIR"
        #fs_copy "$plist" "." 
        #mount | grep " / "
        #sudo chown root:wheel "$plistname" 
        #mount | grep " / "
        ## Expected something like: /dev/disk0s2 on / (hfs, local, journaled, noatime)
    #popd
#}

# param1: filesystem name
# usage:"fasname" "plistname" "
fs_enable_flag_noatime_on_filesystem() {
    IFS= read -d '' plistfile << "EOF" || true
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Label</key>
        <string>PLISTNAME</string>
        <key>ProgramArguments</key>
        <array>
            <string>mount</string>
            <string>-vuwo</string>
            <string>noatime</string>
            <string>VOLUMENAME</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
</plist>
EOF
    
    plistfile="${plistfile//VOLUMENAME/$1}"
    plistfile="${plistfile//PLISTNAME/$2}"

    mount | grep "$1"
    sudo ${SUDO_OPTIONS} sh -c "echo \"${plistfile}\" > \"${MACOSX_SYSTEM_LAUNCH_DAEMON_DIR}/${2}.plist\"" # FIXME permission denied
    sudo ${SUDO_OPTIONS} chown root:wheel "${MACOSX_SYSTEM_LAUNCH_DAEMON_DIR}/${2}.plist"
    mount | grep "$1"
    # Expected something like: /dev/disk0s2 on / (hfs, local, journaled, noatime)

    todolist_add_new_entry "Check noatime flag is on on $2"
}
