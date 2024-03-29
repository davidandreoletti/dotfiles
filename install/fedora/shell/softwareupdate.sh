###############################################################################
# Fedora Software update related functions
###############################################################################

softwareupdate_list_pending_updates() {
    # List software update
    sudo ${SUDO_OPTIONS} dnf list updates
}

softwareupdate_updates_install() {
    sudo ${SUDO_OPTIONS} dnf -y update
}
