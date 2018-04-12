###############################################################################
# VNC related functions
###############################################################################

#param1: username
#param2: vmc password
vnc_user_enable() {
    local USERNAME=$1
    local VNC_PASSWORD=$2
    sudo ${SUDO_OPTIONS} /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -users ${USERNAME} -access -on -privs -all -restart -agent 
    sudo ${SUDO_OPTIONS} /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -users ${USERNAME} -clientopts -setvnclegacy -vnclegacy yes -clientopts -setvncpw -vncpw ${VNC_PASSWORD} -restart -agent 
    sudo ${SUDO_OPTIONS} /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -specifiedUsers
    #sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -users ${USERNAME} -access -on -restart -agent -clientopts -setvnclegacy -vnclegacy yes -clientopts -setvncpw -vncpw ${VNC_PASSWORD} -privs -all -allowAccessFor -specifiedUsers
}
