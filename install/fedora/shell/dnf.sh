###############################################################################
# Fedora's dnf package manager
###############################################################################

# param1: package name
fedora_dnf_install() {
    message_info_show "$1 install ..."
    # Must use default sudo setting. Hence no: -u <user_name>
    sudo ${SUDO_OPTIONS} dnf -y install $@
}

fedora_dnf_group_install() {
    message_info_show "$1 group install ..."
    # Must use default sudo setting. Hence no: -u <user_name>
    sudo ${SUDO_OPTIONS} dnf -y group install "$1"
}


