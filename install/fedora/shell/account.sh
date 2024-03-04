###############################################################################
# Account related functions
###############################################################################

# param1: current user
function account_has_administration_permission() {
    # Can use sudo
    # Support: Debian / Ubuntu 12+ / Fedora
    sudo -n true
    [[ $? -eq 0 ]] && return 0
    return 1 
}

# param1: user
# param2: group
function account_user_remove_group() {
    :
}

#param1: username
function account_exists() {
    local USERNAME="$1"
    id "$USERNAME" >/dev/null 2>&1 && return 0 || return 1
}

# param1: username
# param2: real name
# param3: password
function account_admin_create() {
    local USERNAME="$1"
    local REALNAME="$2"
    local PASSWORD="$3"

    :
}

function account_guest_enable {
	# Does guest already exist?
	if id "guest" &>/dev/null; then
		echo "Guest already created!"
	else
		sudo ${SUDO_OPTIONS} useradd guest -s /bin/zsh -m
		message_info_show "$0: Guest created"
	fi
}


function account_guest_disable {
	sudo ${SUDO_OPTIONS} usermod -L guest

	message_info_show "$0: Guest account disabled"
}

