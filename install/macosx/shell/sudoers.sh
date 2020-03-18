#!/bin/sh
###############################################################################
# Sudo/sudoers related functions
###############################################################################

SUDO_OPTIONS=${SUDO_OPTIONS:-""}
SUDOERS_ORIGINAL_FILE="/etc/sudoers"
# Enable 24 hours timeout 
TIMESTAMP_SUDO_LINE_P0="Defaults"
TIMESTAMP_SUDO_LINE_P1="passwd_timeout="
TIMESTAMP_SUDO_LINE_P2="0"
TIMESTAMP_SUDO_LINE="${TIMESTAMP_SUDO_LINE_P0} ${TIMESTAMP_SUDO_LINE_P1}${TIMESTAMP_SUDO_LINE_P2}"

function sudoers_disable_password_expiry() {
    sudo ${SUDO_OPTIONS} visudo -cf "${SUDOERS_ORIGINAL_FILE}"
    # Inspired from http://www.linuxjournal.com/content/running-complex-commands-sudo
    echo "echo \"${TIMESTAMP_SUDO_LINE}\" >> \"${SUDOERS_ORIGINAL_FILE}\"" | sudo ${SUDO_OPTIONS} sh
    sudo ${SUDO_OPTIONS} visudo -cf "${SUDOERS_ORIGINAL_FILE}"
}

function sudoers_enable_password_expiry() {
    sudo ${SUDO_OPTIONS} visudo -cf "${SUDOERS_ORIGINAL_FILE}"
    echo "sed -i \"\" \"/${TIMESTAMP_SUDO_LINE}/ d\" \"${SUDOERS_ORIGINAL_FILE}\"" | sudo ${SUDO_OPTIONS} sh
    sudo ${SUDO_OPTIONS} visudo -cf "${SUDOERS_ORIGINAL_FILE}"
}

# untested!
function sudoers_setenv_on_add() {
    echo "echo \"Defaults    set_env = on\" >> \"${SUDOERS_ORIGINAL_FILE}\"" | sudo ${SUDO_OPTIONS} sh
}

# untested!
function sudoers_setenv_on_remove() {
   echo "sed '/Defaults set_env = on/d'  >> \"${SUDOERS_ORIGINAL_FILE}\"" | sudo ${SUDO_OPTIONS} sh
}

# untested!
function sudoers_keep_env_add() {
    echo "echo \"Defaults    env_keep += \"$1\"\" >> \"${SUDOERS_ORIGINAL_FILE}\"" | sudo ${SUDO_OPTIONS} sh
}

# untested!
function sudoers_keep_env_remove() {
    echo "sed \"/Defaults env_keep += \"$1\"/d\" >> \"${SUDOERS_ORIGINAL_FILE}\"" | sudo ${SUDO_OPTIONS} sh
}

function sudoers_user_no_password_set() {
    local username="$1"
    echo "echo \"$username ALL = NOPASSWD : ALL\" >> \"${SUDOERS_ORIGINAL_FILE}\"" | sudo ${SUDO_OPTIONS} sh
    visudo -c
}

function sudoers_user_no_password_unset() {
    local username="$1"
    echo "sed \"/$username ALL = NOPASSWD : ALL/d\"  >> \"${SUDOERS_ORIGINAL_FILE}\"" | sudo ${SUDO_OPTIONS} sh
    visudo -c
}

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

