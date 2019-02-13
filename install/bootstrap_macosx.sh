#!/bin/bash
set -x

###############################################################################
# Boostrap new Mac OS X OS
# Prerequisites:
# Xcode installed
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
source "${BOOSTRAP_DIR}/macosx/shell/timemachine.sh"

# Bootstrap setup
## Ask sudo password for askpass. Required to work around sudo timeout within 
## this script process
message_info_show "Enter password for $(whoami) (required):"
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

## Command line applications
## - List of available packages
##  - http://braumeister.org/
##  - http://brewformulas.org/A
is_profile_admin_or_similar && homebrew_brew_install "bash"; 
    sudo bash -c "echo $(brew --prefix)/bin/bash >> /private/etc/shells"; 
    # Use Bash 4.x or better as default shell for current user
is_profile_admin_or_similar && homebrew_brew_install "bash-completion"
is_profile_admin_or_similar && homebrew_brew_tap_install "homebrew/dupes"
is_profile_admin_or_similar && homebrew_brew_install "git" # Get more recent version than the one shipped in Xcode
is_profile_admin_or_similar && homebrew_brew_install "coreutils" # Apple has outdated unix tooling.
is_profile_admin_or_similar && homebrew_brew_install "zsh"
    sudo bash -c "echo $(brew --prefix)/bin/zsh >> /private/etc/shells"; 
    sudo chsh -s $(brew --prefix)/bin/zsh $USER;  
is_profile_admin_or_similar && homebrew_brew_install "zsh-completions"
is_profile_admin_or_similar && homebrew_brew_install "tmux"
is_profile_admin_or_similar && homebrew_brew_install "vim"
is_profile_admin_or_similar && homebrew_brew_install "neovim" && \
    pip2_install "neovim" && pip3_install "neovim" && \ # Install neovim python package
    pip2_install "pynvim" && pip3_install "pynvim"      # Install neovim python bindings package
is_profile_admin_or_similar && homebrew_brew_install "newsbeuter"
is_profile_admin_or_similar && homebrew_brew_install "rsync"
is_profile_admin_or_similar && homebrew_brew_install "neomutt"
is_profile_admin_or_similar && homebrew_brew_install "jenv"
is_profile_admin_or_similar && homebrew_brew_install "nvm"
is_profile_admin_or_similar && homebrew_brew_install "mpd"  # Music player daemon
is_profile_admin_or_similar && homebrew_brew_install "mpc"  # Music player (simple) client
is_profile_admin_or_similar && homebrew_brew_install "pms"  # Music player (tui) client
is_profile_admin_or_similar && homebrew_brew_install "unp"
is_profile_admin_or_similar && homebrew_brew_install "bat"   # cat with highlighting, paging, line numbers support
is_profile_admin_or_similar && homebrew_brew_install "fzf"   # Ctrl+R replacement for searching the history / files
is_profile_admin_or_similar && homebrew_brew_install "fd"    # A simpler find
is_profile_admin_or_similar && homebrew_brew_install "tldr"  # Short manpage version, with example for most comman use cases
is_profile_admin_or_similar && homebrew_brew_install "ncdu"  #Replacement for Grandperspective and du
is_profile_admin_or_similar && homebrew_brew_install "openssh" # Newer SSH Server requires a more recent SSH client than currently shipped in OSX
is_profile_admin_or_similar && homebrew_brew_install "irssi" "--with-perl=yes" "--with-proxy"
is_profile_admin_or_similar && homebrew_brew_install "rlwrap"  # Needed to execute PlistBuddy in command mode
is_profile_admin_or_similar && homebrew_brew_install "tcpdump"  # TCP traffic sniffing
is_profile_admin_or_similar && homebrew_brew_install "ngrep"  # grep for network resource
is_profile_admin_or_similar && homebrew_brew_tap_install "burntsushi/ripgrep" "https://github.com/BurntSushi/ripgrep.git" # rigrep binary compiled, as nightly build, and including SIMD and all optimizations enabled. 
is_profile_admin_or_similar && homebrew_brew_install "ripgrep-bin"  # faster grep
is_profile_admin_or_similar && homebrew_brew_install "jq"  # JSON manipulator
is_profile_admin_or_similar && homebrew_brew_install "aq"  # Fast file content search
is_profile_admin_or_similar && homebrew_brew_install "ack" # Fast file content search too
is_profile_admin_or_similar && homebrew_brew_install "trash" # Move files into macOS user's trash bin (as if done from the Finder)
is_profile_admin_or_similar && homebrew_brew_install "entr" # Run command on files that have changed
is_profile_admin_or_similar && homebrew_brew_install "spaceman-diff" # Git can now diff images as colourfull ASCII approximation
is_profile_admin_or_similar && homebrew_brew_install "imagemagick" # Required by spaceman-diff
is_profile_admin_or_similar && homebrew_brew_install "jp2a" # Convert images to ASCII. Required by spaceman-diff
is_profile_admin_or_similar && homebrew_brew_install "hub" # Unofficial Github CLI (for Pull Requests, etc) 
is_profile_admin_or_similar && homebrew_brew_install "z"    # Smarter cd
is_profile_admin_or_similar && homebrew_brew_install "pv"   # pipe data flow speed progress indicator
is_profile_admin_or_similar && homebrew_brew_install "rename" # Mass file rename
is_profile_admin_or_similar && homebrew_brew_install "moreutils" # parallel, elekdo, etc
is_profile_admin_or_similar && homebrew_brew_install "findutils" # GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
is_profile_admin_or_similar && homebrew_brew_install "gnu-sed" "--with-default-names" # GNU `sed`, overwriting the built-in `sed`
is_profile_admin_or_similar && homebrew_brew_install "xml-coreutils" # Command XML utilities (eg: xml-grep)

## GUI applications
#homebrew_brew_cask_workaround0
is_profile_admin_or_similar && homebrew_brew_tap_install "caskroom/cask"
is_profile_admin_or_similar && homebrew_brew_cask_install "firefox"
is_profile_admin_or_similar && homebrew_brew_cask_install "google-chrome"
is_profile_admin_or_similar && homebrew_brew_cask_install "vlc"
is_profile_admin_or_similar && homebrew_brew_cask_install "java"
is_profile_admin_or_similar && homebrew_brew_cask_install "jetbrains-toolbox"
is_profile_admin_or_similar && homebrew_brew_cask_install "android-studio"
is_profile_admin_or_similar && homebrew_brew_cask_install "sketch"
is_profile_admin_or_similar && homebrew_brew_cask_install "calibre"
is_profile_admin_or_similar && homebrew_brew_cask_install "sourcetree"
is_profile_admin_or_similar && homebrew_brew_cask_install "transmission"
is_profile_admin_or_similar && homebrew_brew_cask_install "skype"
is_profile_admin_or_similar && homebrew_brew_cask_install "dropbox"
is_profile_admin_or_similar && homebrew_brew_cask_install "virtualbox"
is_profile_admin_or_similar && homebrew_brew_cask_install "virtualbox-extension-pack"
is_profile_admin_or_similar && homebrew_brew_cask_install "iterm2"
is_profile_admin_or_similar && homebrew_brew_cask_install "cyberduck"
is_profile_admin_or_similar && homebrew_brew_cask_install "grandperspective"
is_profile_admin_or_similar && homebrew_brew_cask_install "1password"
is_profile_admin_or_similar && homebrew_brew_cask_install "onyx"
is_profile_admin_or_similar && homebrew_brew_cask_install "postman"
is_profile_admin_or_similar && homebrew_brew_cask_install "tunnelblick"
is_profile_admin_or_similar && homebrew_brew_cask_install "textmate"
is_profile_admin_or_similar && homebrew_brew_cask_install "intel-haxm"

## Browser add-ons
is_profile_admin_or_similar && $SHELL -x install/browsers/chrome/extensions/install.sh
is_profile_admin_or_similar && $SHELL -x install/browsers/firefox/extensions/install.sh
 
is_profile_admin_or_similar && pip2_install "awsli" && pip3_install "awscli"


# https://developer.apple.com/library/content/technotes/tn2459/_index.html
is_profile_admin_or_similar && todolist_add_new_entry "Allow Kernel extension from Intel XAM to run: System Preferences > Seucrity Privacy > General Tab > Allow button"

is_profile_admin_or_similar && todolist_add_new_entry "Install Orbicule Undercover: http://www.orbicule.com/undercover/mac/download.php"
is_profile_admin_or_similar && todolist_add_new_entry "Setup License in Orbicule Undercover"

is_profile_admin_or_similar && homebrew_brew_install "mas" # Mac App Store command line too
is_profile_admin_or_similar && homebrew_mas_install "539883307" # LINE Inc
is_profile_admin_or_similar && homebrew_mas_install install 409203825 # Numbers
is_profile_admin_or_similar && homebrew_mas_install install 409201541 # Pages

[[ is_profile_admin || is_profile_dev_single || is_profile_dev_multi ]] && tmux_install_tpm

# Set OSX user/system defaults
bash "${BOOSTRAP_DIR}/macosx/shell/defaults.sh"
timemachine_defaults

# Set TimeMachine backup
# (Failed setup do not stop this script)
sudo tmutil setdestination -a "smb://${CONFIG_MACOSX_TIMEMACHINE_USERNAME}:${CONFIG_MACOSX_TIMEMACHINE_PASSWORD}@nas-server-vm0/NAS_TimeMachine" || message_error_show "Time Machine backup not setup"

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

message_info_show "Apple Softwares: checking updates ..."
softwareupdate_list_pending_updates
message_info_show "Apple Softwares: updates installing ..."
softwareupdate_updates_install

# Users Administration
## Enable Guest
is_profile_admin_or_similar && account_guest_enable
## Create new Administrator account
is_admin_available=$(account_exists "administrator")
account_exists "administrator" || account_admin_create "administrator" "Administrator" "$CONFIG_MACOSX_USER_ADMIN_PASSWORD"
## Remove current user from admin group
## - OSX will ask for Administrator password every time something has to be done (least privileges for day to day tasks)
## - Homebrew's /usr/local/*' folders have group admin. In multi user setup, 
##   users with the "admin" group are the only one allowed to "brew install"
##   DO NOT CHANGE the /usr/local/* group to something - that's futile and agaisnt homebrew's recommendation
is_profile_dev_single && account_user_remove_group "$(whoami)" "admin"
## Change administrator password
$is_admin_available || message_info_show "Change Administrator password :)"
$is_admin_available || sudo ${SUDOERS_OPTIONS} passwd administrator

popd

message_info_show "Machine setup almost complete :)"
todolist_show_read_todolist

