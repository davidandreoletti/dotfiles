###############################################################################
# python related functions
###############################################################################

python_easy_install() {
    sudo ${SUDO_OPTIONS} easy_install -v -v -U $@
    return $?
}

pip3_global_install() {
    sudo ${SUDO_OPTIONS} pip3 install $@
    return $?
}

pip2_global_install() {
    sudo ${SUDO_OPTIONS} pip2 install $@
    return $?
}
