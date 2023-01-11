########################
# Fedora's flatpak package manager
###############################################################################

fedora_flatpak_install () {
    message_info_show "$1 install ..."
    sudo ${SUDO_OPTIONS} flatpak install -y --noninteractive $@
}

fedora_flatpak_flathub_install () {
    message_info_show "$1 install ..."
    sudo ${SUDO_OPTIONS} flatpak install -y --noninteractive "flathub" $@
}

fedora_flatpak_remote_add () {
    sudo ${SUDO_OPTIONS} flatpak remote-add --if-not-exists $@
}
