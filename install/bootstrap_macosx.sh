#!/bin/bash

###############################################################################
# Boostrap new Mac OS X OS
# export DEBUG=; ./<this script> to debug
# Prerequisites:
# Xcode installed
###############################################################################

export BOOSTRAP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd /tmp

# Functions
source "${BOOSTRAP_DIR}/utils/debug.sh"
source "${BOOSTRAP_DIR}/utils/message.sh"
source "${BOOSTRAP_DIR}/config/config.sh"
source "${BOOSTRAP_DIR}/utils/todolist.sh"
source "${BOOSTRAP_DIR}/macosx/shell/sudoers.sh"
source "${BOOSTRAP_DIR}/macosx/shell/xcode.sh"
source "${BOOSTRAP_DIR}/macosx/shell/homebrew.sh"
source "${BOOSTRAP_DIR}/macosx/shell/python.sh"
source "${BOOSTRAP_DIR}/macosx/shell/dmg.sh"
source "${BOOSTRAP_DIR}/macosx/shell/fs.sh"
source "${BOOSTRAP_DIR}/macosx/shell/vnc.sh"
source "${BOOSTRAP_DIR}/macosx/shell/ssh.sh"
source "${BOOSTRAP_DIR}/macosx/shell/ssd.sh"
source "${BOOSTRAP_DIR}/macosx/shell/assistive.sh"
source "${BOOSTRAP_DIR}/macosx/shell/account.sh"
source "${BOOSTRAP_DIR}/macosx/shell/softwareupdate.sh"
source "${BOOSTRAP_DIR}/macosx/shell/ramdisk.sh"
source "${BOOSTRAP_DIR}/macosx/shell/tmux.sh"

# Bootstrap setup
## Ask sudo password for askpass. Required to work around sudo timeout within 
## this script process
message_info_show "Enter password for $(whoami) (required):" #FIXME Check password is correct
read -s p
echo "$p" | sudo -S echo ""

## Temporarily prevent sudo from asking password
ramdisk_create_and_mount_storage "secrets"
export SUDO_OPTIONS="-A"
export SUDO_ASKPASS="/Volumes/secrets/askpass.sh"
echo -e "#!/bin/bash\necho \"${p}\"" > "${SUDO_ASKPASS}"
chmod 700 "${SUDO_ASKPASS}"

## Update existing sudo time stamp if set, otherwise do nothing.
## https://gist.github.com/cowboy/3118588
## Unsecure but it's ok
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## Give current user sudo rights
account_has_administration_permission || message_error_show "Account with admin group required for user management"
account_has_administration_permission || exit 1
sudoers_add_user "$(whoami)"

onexit() {
    # FIXME remove config file with passwords ...
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chown  "$(whoami):staff" "${BOOSTRAP_DIR}/config/config.sh"
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chmod 700 "${BOOSTRAP_DIR}/config/config.sh"
    unset SUDO_ASKPASS
    unset SUDO_OPTIONS

    # FIXME ramdisk secrets must be deleted
    ramdisk_umount_and_destroy_storage "secrets"
}

trap onexit EXIT

if is_debug_off ; then  # FIXME debug on/off is wrong - DEBUG va
xcode_is_installed || xcode_show_not_installed_message
xcode_is_installed || exit 1
message_info_show "Xcode Command Line Tools install ..."
xcode_show_command_line_tool_install_request
message_info_show "Press any key to continue install"
read

## Package manager
message_info_show "Homebrew install ..."
homebrew_is_installed || homebrew_install  #FIXME ask for password 
homebrew_is_installed || message_error_show "failed"
homebrew_is_installed || exit 1

## List of available packages
## http://braumeister.org/
## http://brewformulas.org/A
# FIXME should I brew update or brew upgrade  ?
homebrew_brew_tap_install "homebrew/dupes"
homebrew_brew_install "git" # something more recent than Xcode's
homebrew_brew_install "coreutils"
homebrew_brew_install "zsh"
homebrew_brew_install "tmux"
homebrew_brew_install "vim"
homebrew_brew_install "macvim"
homebrew_brew_install "newsbeuter"
homebrew_brew_install "rsync"
homebrew_brew_install "cmus"
homebrew_brew_install "irssi" "--with-perl=yes" "--with-proxy"
homebrew_brew_install "mutt" "--sidebar-patch" "--trash-patch" "--with-slang"

python_easy_install "goobook" && chmod -v 755 /usr/local/bin; # for mutt

homebrew_brew_cask_workaround0
homebrew_brew_tap_install "caskroom/cask"
homebrew_brew_cask_install "mactex"
homebrew_brew_cask_install "firefox"
homebrew_brew_cask_install "google-chrome"
homebrew_brew_cask_install "vlc"
homebrew_brew_cask_install "java"
homebrew_brew_cask_install "android-studio"
homebrew_brew_cask_install "calibre"
homebrew_brew_cask_install "sourcetree"
homebrew_brew_cask_install "transmission"
homebrew_brew_cask_install "skype"
homebrew_brew_cask_install "dropbox"
homebrew_brew_cask_install "virtualbox"
homebrew_brew_cask_install "virtualbox-extension-pack"
homebrew_brew_cask_install "flux"
homebrew_brew_cask_install "iterm2"
homebrew_brew_cask_install "cyberduck"
homebrew_brew_cask_install "flash-player"
homebrew_brew_cask_install "grandperspective"
homebrew_brew_cask_install "1password"
homebrew_brew_cask_install "onyx"
homebrew_brew_cask_install "textmate"
#homebrew_brew_cask_install "trim-enabler" # El Capitan (OSX 10.11) has trimenable command
#homebrew_brew_cask_install "undercover" Not in brew cask anymore - keep it to remember to install it # require password - cannot override
# will require Defaults        env_keep += "HOME MAIL" in sudoers ?
homebrew_brew_cask_install "intel-haxm" # smae issue as undercover

homebrew_brew_linkapps
fi

tmux_install_tpm

# Set OSX user/system defaults
bash "${BOOSTRAP_DIR}/macosx/shell/defaults.sh"

# FIXME: install dotfiles ???
# $(which git) clone \"$dotfilesURL\" && cd dotfiles && set -- -f && bash -x bootstrap.sh -f && echo 'source ~/.oh-my-shell/oh-my-shellrc' >> ~/.bash_profile && echo 'source ~/.oh-my-shell/oh-my-shellrc' >> ~/.zshrc"


# Services administration
## SSD perf
fs_has_volume "/" || message_info_show "No volume / to enable noatime flag on" 
fs_has_volume "/" && fs_enable_flag_noatime_on_filesystem "/" "com.david.andreoletti.ssd.noatime.volumeroot"
fs_has_volume "/" || message_info_show "No volume /Volumes/Data to enable noatime flag on" 
fs_has_volume "/Volumes/Data" && fs_enable_flag_noatime_on_filesystem "/Volumes/Data" "com.david.andreoletti.ssd.noatime.volumedata"
ssd_enable_trim

## Remote SSH
ssh_user_enable "$(whoami)"  &&  ssh_set_remote_login "on"
## Remote VNC
vnc_user_enable "$(whoami)" "$CONFIG_MACOSX_VNC_PASSWORD"
## Accessibility API
assistive_enable_accessibility_api

message_info_show "Apple Softwares: checking updates ..."
softwareupdate_list_pending_updates
message_info_show "Apple Softwares: updates installing ..."
softwareupdate_updates_install

# Users Administration
## Enable Guest
account_has_administration_permission || message_error_show "Account with admin group required for user management"
account_has_administration_permission || exit 1
account_guest_enable
## Create new Administrator account
account_admin_create "administrator" "Administrator" "$CONFIG_MACOSX_USER_ADMIN_PASSWORD"
## Remove current user from admin group
## OSX will ask for Administrator password every time something
## has to be done (least privileges for day to day tasks)
account_user_remove_group "$(whoami)" "admin"
## Change administrator password
message_info_show "Change Administrator password :)"
sudo ${SUDOERS_OPTIONS} passwd administrator

popd

message_info_show "Machine setup almost complete :)"
todolist_show_read_todolist

