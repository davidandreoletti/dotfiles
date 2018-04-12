###############################################################################
# SSH related functions
###############################################################################

DSCL='/usr/bin/dscl'

#param: on OR off
ssh_set_remote_login() {
    sudo ${SUDO_OPTIONS} systemsetup -setremotelogin "$1"
}

#param1: username
ssh_user_enable() {
    local USERNAME=$1
    # Src: http://support.apple.com/kb/ht2370
    # Src: http://ss64.com/osx/kickstart.html
    # Src: http://superuser.com/questions/166179/how-to-enable-remote-access-for-another-account-on-mac-remotely-via-ssh/166188#166188
    # Src: http://macadmincorner.com/securing-ssh

    # If the returned value says com.apple.access_ssh-disabled then all users have SSH access. If not, then we need to give the user access.
    sudo ${SUDO_OPTIONS} $DSCL . list /Groups | grep 'com.apple.access_ssh'

    # Create group
    sudo ${SUDO_OPTIONS} dseditgroup -o create -q com.apple.access_ssh

    # To add the user you need to run:
    sudo ${SUDO_OPTIONS} $DSCL . append /Groups/com.apple.access_ssh GroupMembership ${USERNAME}
    sudo ${SUDO_OPTIONS} $DSCL . append /Groups/com.apple.access_ssh groupmembers `sudo ${SUDO_OPTIONS} dscl . read /Users/${USERNAME} GeneratedUID | cut -d " " -f 2`
}
