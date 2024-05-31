###############################################################################
# Archlinux Software update related functions
###############################################################################

softwareupdate_list_pending_updates() {
    # Update software database
    sudo ${SUDO_OPTIONS} pacman -Sy
    # List software update
    sudo ${SUDO_OPTIONS} pacman -Qu
}

softwareupdate_updates_install() {
    sudo ${SUDO_OPTIONS} pacman -Syu --noconfirm
}
