function sudoers_add_user() {
    local current_user="$1"
    local stderr_file="/tmp/bootstrap.$$.sudoers.log"

    if sudo visudo -c 1>${stderr_file} 2>&1; then
        :
    else
        if grep "bad permission" "${stderr_file}"; then
            rm -fv "$stderr_file"
        else
            cat "$stderr_file"
            exit 1
        fi
    fi

    local sudoersFile="/etc/sudoers.d/bootstrap-machine" # file name must not contain '.' or '~'
    sudo touch "$sudoersFile"
    # needed to create a empty file with 1 empty line for sed to append after the last line
    sudo echo "" > "$sudoersFile" 
    local pattern="$ a\\
    # Added by boostrap-machine script\\
    $current_user	ALL=\(ALL\) ALL"

    sudo sed -i.bak -e "$pattern" "$sudoersFile"
    sudo chmod 0440 "$sudoersFile"

    if sudo visudo -c 1>${stderr_file} 2>&1; then
        :
    else
        if grep "bad permission" "${stderr_file}"; then
            rm -fv "$stderr_file"
        else
            cat "$stderr_file"
            exit 1
        fi
    fi
}
