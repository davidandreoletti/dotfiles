function sudoers_add_user() {
    sudo visudo -c

    local sudoersFile="/etc/sudoers.d/bootstrap-machine" # file name must not contain '.' or '~'
    local current_user="$1"
    local pattern="$ a\\
    # Added by boostrap-machine script\\
    $current_user	ALL=\(ALL\) ALL"

    sudo touch "$sudoersFile"
    sudo chmod 0440 "$sudoersFile"
    sudo sed -i.bak -e "$pattern" "$sudoersFile"

    sudo visudo -c
}
