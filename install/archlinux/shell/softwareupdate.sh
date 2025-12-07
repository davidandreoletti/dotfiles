###############################################################################
# Archlinux Software update related functions
###############################################################################

softwareupdate_list_pending_updates() {
    # Update software database
    if ! sudo ${SUDO_OPTIONS} pacman -Sy; then
        # Silence non 0 exit
        :
    fi
    # List software update
    if ! sudo ${SUDO_OPTIONS} pacman -Qu; then
        # Silence non 0 exit
        :
    fi
}

softwareupdate_updates_install() {
    if ! sudo ${SUDO_OPTIONS} pacman -Syu --noconfirm; then
        # Silence non 0 exit
        :
    fi
}
