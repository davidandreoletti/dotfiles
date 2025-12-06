ETC_SUDOERS_D_DIR="/etc/sudoers.d"

function sudoers_add_profile() {
    local profile_name="$1"
    local current_user="$2"
    local capability="${3:-default}"

    if test "$capability" = "default"; then
	capability="$current_user ALL=(ALL) ALL"
    elif test "$capability" = "bootstrap_permission"; then
	    capability="$current_user ALL=(ALL) NOPASSWD: ALL"
    fi

    sudoers_add_capability "${profile_name}_${current_user}" "$capability"
}

function sudoers_remove_profile() {
    local profile_name="$1"
    local current_user="$2"

    sudoers_remove_capability "${profile_name}_${current_user}"
}

function sudoers_remove_capability() {
    local profile_file="$1"

    local sudoers_file="$ETC_SUDOERS_D_DIR/$profile_file" 
    if sudo test -f "$sudoers_file"; then
        sudo rm -v "$sudoers_file"
    fi
}

function sudoers_add_capability() {
    local profile_file="$1"
    local capability="$2"
    local stderr_file="/tmp/bootstrap.$$.sudoers.add_capability.$profile_file.log"

    if ! sudoers_verify "${stderr_file}"; then
	    exit 1
    fi

    # file name must not contain '.' or '~'
    local sudoers_file="$ETC_SUDOERS_D_DIR/$profile_file" 

    sudo tee "$sudoers_file" > /dev/null <<-EOF
	# Added by dotfiles's bootstrap.sh script
	$capability
	EOF
    sudo chmod 0440 "$sudoers_file"

    if ! sudoers_verify "${stderr_file}"; then
	    exit 1
    fi
}

function sudoers_verify() {
    local stderr_file="$1"

    if sudo visudo -c 1>${stderr_file} 2>&1; then
        return 0
    else
        if grep "bad permission" "${stderr_file}"; then
            rm -fv "$stderr_file"
	    return 1
        else
            cat "$stderr_file"
            return 1
        fi
    fi
}
