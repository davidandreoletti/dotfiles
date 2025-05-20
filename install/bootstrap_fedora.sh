#!/bin/bash
set -e

###############################################################################
# Boostrap new Fedora
# Prerequisites:
# - dnf
###############################################################################

export BOOSTRAP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export BOOTSTRAP_PROFILE="$1"

pushd /tmp

# Functions
source "${BOOSTRAP_DIR}/utils/profile.sh"
source "${BOOSTRAP_DIR}/utils/debug.sh"
source "${BOOSTRAP_DIR}/utils/message.sh"
source "${BOOSTRAP_DIR}/config/config.sh"
source "${BOOSTRAP_DIR}/utils/todolist.sh"
source "${BOOSTRAP_DIR}/common/shell/priority.sh"
source "${BOOSTRAP_DIR}/common/shell/os.sh"
source "${BOOSTRAP_DIR}/common/shell/arch.sh"
source "${BOOSTRAP_DIR}/common/shell/homebrew.sh"
source "${BOOSTRAP_DIR}/common/shell/bash.sh"
source "${BOOSTRAP_DIR}/common/shell/python.sh"
source "${BOOSTRAP_DIR}/common/shell/pipx.sh"
source "${BOOSTRAP_DIR}/common/shell/rust.sh"
source "${BOOSTRAP_DIR}/common/shell/tmux.sh"
source "${BOOSTRAP_DIR}/common/shell/sudo.sh"
source "${BOOSTRAP_DIR}/common/shell/user_password.sh"
source "${BOOSTRAP_DIR}/common/shell/container.sh"
source "${BOOSTRAP_DIR}/common/shell/systemd.sh"
source "${BOOSTRAP_DIR}/common/shell/ci.sh"
source "${BOOSTRAP_DIR}/common/shell/vscode.sh"
source "${BOOSTRAP_DIR}/fedora/shell/sudoers.sh"
source "${BOOSTRAP_DIR}/fedora/shell/vnc.sh"
source "${BOOSTRAP_DIR}/fedora/shell/ssh.sh"
source "${BOOSTRAP_DIR}/fedora/shell/account.sh"
source "${BOOSTRAP_DIR}/fedora/shell/softwareupdate.sh"
source "${BOOSTRAP_DIR}/fedora/shell/ramdisk.sh"
source "${BOOSTRAP_DIR}/fedora/shell/backup.sh"
source "${BOOSTRAP_DIR}/fedora/shell/dnf.sh"
source "${BOOSTRAP_DIR}/fedora/shell/flatpak.sh"
source "${BOOSTRAP_DIR}/fedora/shell/snap.sh"

# Bootstrap setup
## Ask sudo password for askpass. Required to work around sudo timeout within 
## this script process
if is_bootstrap_noninteractive; then
    p=""
else
    p="$(ask_user_password)"
fi

## Temporarily prevent sudo from asking password
ramdisk_create_and_mount_storage "secrets"
export SUDO_OPTIONS="-A --preserve-env=PATH,HOMEBREW_PREFIX"
export SUDO_ASKPASS="$CURRENT_MOUNT_DIR/askpass.sh"
echo -e "#!/bin/bash\necho \"${p}\"" > "${SUDO_ASKPASS}"
chmod 700 "${SUDO_ASKPASS}"

## Update existing sudo time stamp if set, otherwise do nothing.
## https://gist.github.com/cowboy/3118588
## Unsecure and it's ok
sudo_refresh

## Give current user sudo rights
if account_has_administration_permission; then
    :
else
    message_error_show "Account with admin group required for user management"
    exit 1
fi
if is_profile_dev_single; then
    sudoers_add_user "$(whoami)"
fi

onexit() {
    # FIXME remove config file with passwords ...
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chown  "$(whoami):$(whoami)" "${BOOSTRAP_DIR}/config/config.sh"
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chmod 700 "${BOOSTRAP_DIR}/config/config.sh"
    unset SUDO_ASKPASS
    unset SUDO_OPTIONS

    ramdisk_umount_and_destroy_storage "secrets"
}

trap onexit EXIT

FEDORA_DNF_INSTALL_AGGREGATED=0
HOMEBREW_BREW_INSTALL_AGGREGATED=0

## Package managers
### Install homebrew prerequisites
fedora_dnf_install "@development-tools"
fedora_dnf_install "procps-ng"
fedora_dnf_install "curl"
fedora_dnf_install "file"
fedora_dnf_install "git"

fedora_dnf_install "__commit_aggregated__"

## Package manager
message_info_show "Homebrew install ..."
homebrew_package_manager_install
if homebrew_is_installed; then
    :
else
    exit 1
fi

### Install flatpak prerequisites
fedora_dnf_install "flatpak"
### Install snaps prerequisites
fedora_dnf_install "snapd"
# Fedora's official 3rd party reposititories
fedora_dnf_install fedora-workstation-repositories
# Hardware drivers (eg: nvidia)
fedora_dnf_install "@hardware-support"

fedora_dnf_install "__commit_aggregated__"

# Applications
SHELLS_FILE="/etc/shells"
source "${BOOSTRAP_DIR}/bootstrap_apps.sh"

# Set user/system defaults
bash "${BOOSTRAP_DIR}/fedora/shell/defaults.sh"

# Set Timeshift backup. WARNING: backup only system files https://teejeetech.com/timeshift/

# (Failed TM setup must not stop this script)
smb_uri="smb://${CONFIG_fedora_TIMEMACHINE_USERNAME}:${CONFIG_fedora_TIMEMACHINE_PASSWORD}@nas-server-vm0/NAS_Timeshift"
smb_uri2="smb://nas-server-vm0/NAS_Timeshift"
smb_volume="/Volumes/NAS_Timeshift"

# Services administration
## SSD perf
# TRIM enabled by default since at least macOS High Sierra

## Remote SSH
#ssh_user_enable "$(whoami)"  &&  ssh_set_remote_login "on"
## Remote VNC
#vnc_user_enable "$(whoami)" "$CONFIG_fedora_VNC_PASSWORD"

if test "$BOOTSTRAP_SKIP_OS_SOFTWARE_UPDATE_SETUP" = "0"; then
    message_info_show "Skip OS software updates"
else
    message_info_show "Softwares updates checks / installations ..."
    softwareupdate_list_pending_updates
    softwareupdate_updates_install
fi

# Users Administration
## Enable Guest
if is_profile_admin_or_similar; then
    account_guest_enable
fi
## Create new Administrator account
### Use root

popd

message_info_show "Machine setup almost complete"
todolist_show_read_todolist

