###############################################################################
# Apple Software update related functions
###############################################################################

softwareupdate_list_pending_updates() {
    # List software update
    sudo ${SUDO_OPTIONS} softwareupdate -l
}

softwareupdate_updates_install() {
    # Install ALL software update (may require sudo)
    todolist_add_new_entry "Install software updates" \
    "with: sudo softwareupdate --install -all" \
    "(restart required)"
}
