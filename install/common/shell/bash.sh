bash_command_curl () {
    message_info_show "$1 Bash installer install $1 ..."

    checksum="$(echo "$1" | sha256sum | cut -d' ' -f1)"
    local installer_file="/tmp/$$.${checksum}.installer.sh"

    if test -f "$installer_file"; then
	echo "Already installed: $1"    
    else
        sudo rm -fv ""$installer_file
        sudo ${SUDO_OPTIONS} curl -fsSL $1 --output "$installer_file"
        sudo ${SUDO_OPTIONS} bash "$installer_file"

        touch "$installer_file"
    fi
}

bash_command_curl_no_sudo () {
    message_info_show "$1 Bash installer install $1 ..."

    checksum="$(echo "$1" | sha256sum | cut -d' ' -f1)"
    local installer_file="/tmp/$$.${checksum}.installer.nosudo.sh"

    if test -f "$installer_file"; then
	echo "Already installed: $1"    
    else
        rm -fv ""$installer_file
        curl -fsSL $1 --output "$installer_file"
        bash "$installer_file"

        touch "$installer_file"
    fi
}
