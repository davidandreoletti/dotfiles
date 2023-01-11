###############################################################################
# Fedora's dnf package manager
###############################################################################

# param1: package name
fedora_snap_install () {
    message_info_show "$1 install ..."
    sudo ${SUDO_OPTIONS} snap install $@
}

