###############################################################################
# Fedora Software update related functions
###############################################################################

softwareupdate_list_pending_updates() {
    # List software update
    sudo ${SUDO_OPTIONS} dnf list updates
    local exitCode=$?

    # DNF returns:
    # 100: Updates available
    # 1: error occured
    # 0: No updates available and no error
    if test $exitCode = 100; then
        return 0
    fi
    return $exitCode
}

softwareupdate_updates_install() {
    sudo ${SUDO_OPTIONS} dnf -y update
}
