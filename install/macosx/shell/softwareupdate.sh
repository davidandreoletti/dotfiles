###############################################################################
# Apple Software update related functions
###############################################################################

softwareupdate_list_pending_updates() {
    # List software update
    sudo ${SUDO_OPTIONS} softwareupdate -l
}

softwareupdate_install_updates() {
    sudo softwareupdate --install -all
}
