###############################################################################
# python related functions
###############################################################################

python_easy_install() {
    easy_insall=$(which easy_install)
    sudo ${SUDO_OPTIONS} $easy_install -v -v -U $@
    return $?
}

pip3_global_install() {
    pip3=$(which pip3)
    sudo ${SUDO_OPTIONS} $pip3 install $@
    return $?
}

pip2_global_install() {
    pip2=$(which pip2)
    sudo ${SUDO_OPTIONS} $pip2 install $@
    return $?
}
