#!/bin/bash
set -e

###############################################################################
# Boostrap new macOS 
# Prerequisites:
# - Xcode installed
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
source "${BOOSTRAP_DIR}/common/shell/os.sh"
source "${BOOSTRAP_DIR}/common/shell/homebrew.sh"
source "${BOOSTRAP_DIR}/common/shell/python.sh"
source "${BOOSTRAP_DIR}/common/shell/pipx.sh"
source "${BOOSTRAP_DIR}/common/shell/rust.sh"
source "${BOOSTRAP_DIR}/common/shell/tmux.sh"
source "${BOOSTRAP_DIR}/common/shell/sudo.sh"
source "${BOOSTRAP_DIR}/common/shell/user_password.sh"
source "${BOOSTRAP_DIR}/common/shell/container.sh"
source "${BOOSTRAP_DIR}/macosx/shell/sudoers.sh"
source "${BOOSTRAP_DIR}/macosx/shell/xcode.sh"
source "${BOOSTRAP_DIR}/macosx/shell/dmg.sh"
source "${BOOSTRAP_DIR}/macosx/shell/fs.sh"
source "${BOOSTRAP_DIR}/macosx/shell/vnc.sh"
source "${BOOSTRAP_DIR}/macosx/shell/ssh.sh"
source "${BOOSTRAP_DIR}/macosx/shell/ssd.sh"
source "${BOOSTRAP_DIR}/macosx/shell/assistive.sh"
source "${BOOSTRAP_DIR}/macosx/shell/account.sh"
source "${BOOSTRAP_DIR}/macosx/shell/softwareupdate.sh"
source "${BOOSTRAP_DIR}/macosx/shell/ramdisk.sh"
source "${BOOSTRAP_DIR}/macosx/shell/timemachine.sh"

# Enable Full Disk Access for the terminal (no way to automate this nor detect it programmatically: https://apple.stackexchange.com/a/398405
# echo "Enable Full Disk Access to the Terminal: System > Preferences > Security & Privacy > Privacy Tab > Full Disk Access > Enable Terminal > Restart the terminal"
# echo "Press any key to continue, ALTHOUGH YOU MUST KILL THE TERMINAL and RUN THE SCRIPT AGAIN FOR THE CHANGES TO TAKE EFFECT
if is_bootstrap_noninteractive; then
    :
else
    read -s nothing
fi

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
export SUDO_OPTIONS="-A"
export SUDO_ASKPASS="$CURRENT_MOUNT_DIR/askpass.sh"
echo -e "#!/bin/bash\necho \"${p}\"" > "${SUDO_ASKPASS}"
chmod 700 "${SUDO_ASKPASS}"

## Update existing sudo time stamp if set, otherwise do nothing.
## https://gist.github.com/cowboy/3118588
## Unsecure and it's ok
sudo_refresh

## Give current user sudo rights
account_has_administration_permission || message_error_show "Account with admin group required for user management"
account_has_administration_permission || exit 1
is_profile_dev_single && sudoers_add_user "$(whoami)"

onexit() {
    # FIXME remove config file with passwords ...
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chown  "$(whoami):staff" "${BOOSTRAP_DIR}/config/config.sh"
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chmod 700 "${BOOSTRAP_DIR}/config/config.sh"
    unset SUDO_ASKPASS
    unset SUDO_OPTIONS

    ramdisk_umount_and_destroy_storage "secrets"
}

trap onexit EXIT

if xcode_is_installed; then
    if xcode_cli_is_installed; then
        message_info_show "Xcode Command Line Tools already installed"
    else
        message_info_show "Xcode Command Line Tools install ..."
        xcode_show_command_line_tool_install_request
        message_info_show "Press any key to continue install"
        read
    fi
else
    xcode_show_not_installed_message
    exit 1
fi

HOMEBREW_BREW_INSTALL_AGGREGATED=0

## Package manager
message_info_show "Homebrew install ..."
homebrew_package_manager_install
homebrew_is_installed && is_profile_admin_or_similar && homebrew_fix_writable_dirs "$(whoami)"
homebrew_is_installed || exit 1
#homebrew_brew_cask_workaround0

# Applications
SHELLS_FILE="/private/etc/shells"
source "${BOOSTRAP_DIR}/bootstrap_apps.sh"


## Browser add-ons
pushd "$BOOSTRAP_DIR"
is_profile_admin_or_similar && $SHELL -x ../install/browsers/chrome/extensions/install.sh
is_profile_admin_or_similar && $SHELL -x ../install/browsers/firefox/extensions/install.sh
popd

# Set user/system defaults
bash "${BOOSTRAP_DIR}/macosx/shell/defaults.sh"
timemachine_defaults

# Set TimeMachine backup
# tmutil destinationinfo
# ====================================================
# Name          : NAS_TimeMachine
# Kind          : Network
# URL           : smb://davidandreoletti@nas-server-vm0/NAS_TimeMachine
# ID            : 4437C0CE-5C88-4113-B52A-CA325E8ACD1A

# (Failed TM setup must not stop this script)
smb_uri="smb://${CONFIG_MACOSX_TIMEMACHINE_USERNAME}:${CONFIG_MACOSX_TIMEMACHINE_PASSWORD}@nas-server-vm0/NAS_TimeMachine"
smb_uri2="smb://nas-server-vm0/NAS_TimeMachine"
smb_volume="/Volumes/NAS_TimeMachine"

if sudo tmutil setdestination -a "$smb_uri"
then
    # TimeMachine backup set but not auto mounted
    sudo tmutil destinationinfo
else
    # Requires NAS_Timemachine to be setup an automatically mounted (at X session login time)
    echo "Finder: Mount $smb_uri2 + Save mount endpoints as user Login Item."
    echo "When completed, press Enter to continue";
    read -p nothing

    if sudo tmutil setdestination -a "$smb_volume"
    then 
        # TimeMachine backup set but not auto mounted ?
        sudo tmutil destinationinfo
    else
        message_error_show "Time Machine backup not setup automatically: $smb_uri / $smb_volume"
        todolist_add_new_entry "Time Machine backup mUST be setup manually: $smb_uri / $smb_volume"
    fi
fi

# Services administration
## SSD perf
fs_has_volume "/" || message_info_show "No volume / to enable noatime flag on" 
fs_has_volume "/" && fs_enable_flag_noatime_on_filesystem "/" "com.david.andreoletti.ssd.noatime.volumeroot"
# TRIM enabled by default since at least macOS High Sierra

## Remote SSH
#ssh_user_enable "$(whoami)"  &&  ssh_set_remote_login "on"
## Remote VNC
#vnc_user_enable "$(whoami)" "$CONFIG_MACOSX_VNC_PASSWORD"
## Accessibility API
assistive_enable_accessibility_api

message_info_show "Softwares updates checks / installations ..."
softwareupdate_list_pending_updates
softwareupdate_updates_install

# Users Administration
## Enable Guest
is_profile_admin_or_similar && account_guest_enable
## Create new Administrator account
is_admin_available=$(account_exists "administrator")
account_exists "administrator" || account_admin_create "administrator" "Administrator" "$CONFIG_MACOSX_USER_ADMIN_PASSWORD"
## Remove current user from admin group
## Consequences:
## - macOS
## -- OS asks for Administrator password every time something has to be done (least privileges for day to day tasks)
## - Homebrew:
## -- /usr/local/*' folders have group admin. In multi user setup, 
##   users with the "admin" group are the only one allowed to "brew install"
##   DO NOT CHANGE the /usr/local/* group to something - that's futile and agaisnt homebrew's recommendation
is_profile_dev_single && account_user_remove_group "$(whoami)" "admin"
## Change administrator password
$is_admin_available || message_info_show "Change Administrator password"
$is_admin_available || sudo ${SUDOERS_OPTIONS} passwd administrator

popd

message_info_show "Machine setup almost complete"
todolist_show_read_todolist

