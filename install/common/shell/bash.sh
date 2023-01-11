bash_command_curl () {
    message_info_show "$1 Bash installer install $1 ..."
    rm -f /tmp/installer.sh
    sudo ${SUDO_OPTIONS} curl -fsSL $1 --output /tmp/installer.sh
    sudo ${SUDO_OPTIONS} bash /tmp/installer.sh
}
