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

# Enable Full Disk Access for the terminal (no way to automate this nor detect it programmatically: https://apple.stackexchange.com/a/398405
# echo "Enable Full Disk Access to the Terminal: System > Preferences > Security & Privacy > Privacy Tab > Full Disk Access > Enable Terminal > Restart the terminal"
# echo "Press any key to continue, ALTHOUGH YOU MUST KILL THE TERMINAL and RUN THE SCRIPT AGAIN FOR THE CHANGES TO TAKE EFFECT
read -s nothing

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
homebrew_is_installed && is_profile_admin_or_similar && homebrew_fix_writable_dirs "$(whoami)"
homebrew_is_installed || exit 1

## Command line applications
## - List of available packages
##  - http://braumeister.org/
##  - http://brewformulas.org/A

# Python version for OS & utilities
is_profile_admin_or_similar && homebrew_brew_install "python3" && homebrew_brew_link "python3" && homebrew_postinstall "python3"
# Python version manager for development projects 
is_profile_admin_or_similar &&  homebrew_brew_install  "pyenv"              # Manage python version on a per user/folder basis
is_profile_admin_or_similar &&  homebrew_brew_install  "pyenv-virtualenv"  # pyenv plugin: virtualenv/venv
# Use Bash 4.x or better as default shell for current user
is_profile_admin_or_similar  &&  homebrew_brew_install  "bash"             &&  sudo  bash  -c  "echo  $(brew  --prefix)/bin/bash  >>  /private/etc/shells";
is_profile_admin_or_similar  &&  homebrew_brew_install  "bash-completion"
is_profile_admin_or_similar  &&  homebrew_brew_tap_install "homebrew/services"    # Launch services in background. 
is_profile_admin_or_similar  &&  homebrew_brew_install  "git"        # Get more recent version than the one shipped in Xcode
is_profile_admin_or_similar  &&  homebrew_brew_install  "coreutils"  # Apple has outdated unix tooling.
is_profile_admin_or_similar  &&  homebrew_brew_install  "findutils"  # GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
is_profile_admin_or_similar  &&  homebrew_brew_install  "gnu-sed"    # Apple has outdated unix tooling. sed is another one

is_profile_admin_or_similar  &&  homebrew_brew_install  "zsh" && sudo bash -c "echo $(brew --prefix)/bin/zsh >> /private/etc/shells" && sudo chsh -s $(brew --prefix)/bin/zsh $USER; 
is_profile_admin_or_similar  &&  homebrew_brew_install  "zsh-completions"
is_profile_admin_or_similar  &&  homebrew_brew_install  "tmux"
is_profile_admin_or_similar  &&  homebrew_brew_install  "vim"

# Install neovim, neovim python package, neovim python bindings package
is_profile_admin_or_similar && homebrew_brew_install "neovim" && pip3_global_install "neovim" && pip3_global_install "pynvim" 

is_profile_admin_or_similar   &&  pip3_global_install        "tasklog"             # Install tasklog cli
is_profile_admin_or_similar   &&  homebrew_brew_install      "newsbeuter"
is_profile_admin_or_similar   &&  homebrew_brew_install      "rsync"
is_profile_admin_or_similar   &&  homebrew_brew_install      "gdb"                 # versatile debugger
is_profile_admin_or_similar   &&  homebrew_brew_install      "neomutt"
is_profile_admin_or_similar   &&  homebrew_brew_install      "jenv"
is_profile_admin_or_similar   &&  homebrew_brew_install      "htop"
is_profile_admin_or_similar   &&  homebrew_brew_install      "nvm"
is_profile_admin_or_similar   &&  homebrew_brew_install      "wget"
is_profile_admin_or_similar   &&  homebrew_brew_install      "goenv"               # Golang environment manager
is_profile_admin_or_similar   &&  homebrew_brew_install      "asdf"                # Version manager for multiple runtime environment
is_profile_admin_or_similar   &&  homebrew_brew_install      "util-linux"          # Collection of linux utilies
is_profile_admin_or_similar   &&  homebrew_brew_install      "redis"               # Redis Key Value Storage
is_profile_admin_or_similar   &&  homebrew_brew_install      "curl"
is_profile_admin_or_similar   &&  homebrew_brew_install      "mpd"                 # Music player daemon
is_profile_admin_or_similar   &&  homebrew_brew_install      "mpc"                 # Music player (simple) client
is_profile_admin_or_similar   &&  homebrew_brew_install      "pms"                 # Music player (tui) client
is_profile_admin_or_similar   &&  homebrew_brew_install      "unp"
is_profile_admin_or_similar   &&  homebrew_brew_install      "rar"                 # RAR files
is_profile_admin_or_similar   &&  homebrew_brew_install      "bat"                 # cat with highlighting, paging, line numbers support
is_profile_admin_or_similar   &&  homebrew_brew_install      "fzf"                 # Ctrl+R replacement for searching the history / files
is_profile_admin_or_similar   &&  homebrew_brew_install      "fd"                  # A simpler find
is_profile_admin_or_similar   &&  homebrew_brew_install      "tldr"                # Short manpage version, with example for most comman use cases
is_profile_admin_or_similar   &&  homebrew_brew_install      "ncdu"                #Replacement for Grandperspective and du
is_profile_admin_or_similar   &&  homebrew_brew_install      "openssh"             # Newer SSH Server requires a more recent SSH client than currently shipped in OSX
is_profile_admin_or_similar   &&  homebrew_brew_install      "irssi"               # IRC client. Note: --with-perl=yes --with-proxy included since brew irssi formula v1.2.3
is_profile_admin_or_similar   &&  homebrew_brew_install      "rlwrap"              # Needed to execute PlistBuddy in command mode
is_profile_admin_or_similar   &&  homebrew_brew_install      "tcpdump"             # TCP traffic sniffing
is_profile_admin_or_similar   &&  homebrew_brew_install      "ngrep"               # grep for network resource
is_profile_admin_or_similar   &&  homebrew_brew_tap_install  "burntsushi/ripgrep"  "https://github.com/BurntSushi/ripgrep.git"  #                      rigrep            binary         compiled,        as            nightly    build,         and     including      SIMD      and        all      optimizations  enabled.
is_profile_admin_or_similar   &&  homebrew_brew_install      "ripgrep-bin"         # faster grep
is_profile_admin_or_similar   &&  homebrew_brew_install      "jq"                  # JSON manipulator
is_profile_admin_or_similar   &&  homebrew_brew_install      "python-yq"           # YAML manipulator. Requires: jq
is_profile_admin_or_similar   &&  homebrew_brew_install      "ack"                 # Fast file content search too
is_profile_admin_or_similar   &&  homebrew_brew_install      "trash"               # Move files into macOS user's trash bin (as if done from the Finder)
is_profile_admin_or_similar   &&  homebrew_brew_install      "entr"                # Run command on files that have changed
is_profile_admin_or_similar   &&  homebrew_brew_install      "spaceman-diff"       # Git can now diff images as colourfull ASCII approximation
is_profile_admin_or_similar   &&  homebrew_brew_install      "imagemagick"         # Required by spaceman-diff
is_profile_admin_or_similar   &&  homebrew_brew_install      "jp2a"                # Convert images to ASCII. Required by spaceman-diff
is_profile_admin_or_similar   &&  homebrew_brew_install      "hub"                 # Unofficial Github CLI (for Pull Requests, etc)
is_profile_admin_or_similar   &&  homebrew_brew_install      "z"                   # Smarter cd
is_profile_admin_or_similar   &&  homebrew_brew_install      "pv"                  # pipe data flow speed progress indicator
is_profile_admin_or_similar   &&  homebrew_brew_install      "dive"                # Inspect docker layers
is_profile_admin_or_similar   &&  homebrew_brew_install      "rename"              # Mass file rename
is_profile_admin_or_similar   &&  homebrew_brew_install      "moreutils"           # parallel, elekdo, etc
is_profile_admin_or_similar   &&  homebrew_brew_install      "mitmproxy"           # Charles Proxy in command line
is_profile_admin_or_similar   &&  homebrew_brew_install      "tree"
is_profile_admin_or_similar   &&  homebrew_brew_install      "gnu-sed"             # GNU `sed`, overwriting the built-in `sed`
is_profile_admin_or_similar   &&  homebrew_brew_install      "xml-coreutils"       # Command XML utilities (eg: xml-grep)
is_profile_admin_or_similar   &&  homebrew_brew_install      "lynx"                # Terminal browser
is_profile_admin_or_similar   &&  homebrew_brew_install      "rbenv"               # Ruby Version Installer and manager
is_profile_admin_or_similar   &&  homebrew_brew_install      "gawk"                # Required by: tmux-fingers plugin
is_profile_admin_or_similar   &&  homebrew_brew_install      "ffsend"              # Firefox Send client. Required by 1 oh-my-shell plugin
is_profile_admin_or_similar   &&  homebrew_brew_install      "csvkit"              # Swiss army knife for csv files
is_profile_admin_or_similar   &&  homebrew_brew_install      "libiconv"            # Convert files from/to various character encodings
is_profile_admin_or_similar   &&  homebrew_brew_install      "postgresql"          # Postgresql DB and standard command line utils like psql. PG db not started at runtime.
is_profile_admin_or_similar   &&  homebrew_brew_install      "pspg"                # Pager for psql official client
is_profile_admin_or_similar   &&  homebrew_brew_install      "proctools"           # GNU pkill, pgrep
is_profile_admin_or_similar   &&  homebrew_brew_install      "translate-shell"     # Translate any languages
is_profile_admin_or_similar   &&  homebrew_brew_install      "qrencode"            # Generae QR code
is_profile_admin_or_similar   &&  homebrew_brew_install      "httpie"              # Curl simplified
is_profile_admin_or_similar   &&  homebrew_brew_install      "libqalculate"        # qalc: General pupose calculator, to convert unit / dimension analysis
is_profile_admin_or_similar   &&  homebrew_brew_install      "rename"              # Mass rename files.
is_profile_admin_or_similar   &&  homebrew_brew_install      "shellcheck"          # Linting for bash/sh shells scripts
is_profile_admin_or_similar   &&  homebrew_brew_install      "gnupg"               # GNU implementation of PGP
is_profile_admin_or_similar   &&  homebrew_brew_install      "pinentry-mac"        # Connect gpg-agent to OSX keychain
is_profile_admin_or_similar   &&  homebrew_brew_install      "hopenpgp-tools"      # Verify PGP key setup best practice
is_profile_admin_or_similar   &&  homebrew_brew_install      "pgpdump"             # PGP packet/key analyser
is_profile_admin_or_similar   &&  homebrew_brew_install      "libfaketime"         # Freeze system clock for a given application (eg: shell script)
is_profile_admin_or_similar   &&  homebrew_brew_install      "expect"              # Automate interactive program interactions
is_profile_admin_or_similar   &&  homebrew_brew_install      "git-crypt"           # Encrypt git repository
is_profile_admin_or_similar   &&  homebrew_brew_install      "iperf3"              # Network performance measurement
is_profile_admin_or_similar   &&  homebrew_brew_install      "inetutils"           # GNU ftp comand and more
is_profile_admin_or_similar   &&  homebrew_brew_install      "java"
is_profile_admin_or_similar   &&  homebrew_brew_install      "libvirt"
is_profile_admin_or_similar   &&  homebrew_brew_install      "qemu"
#is_profile_admin_or_similar   &&  homebrew_brew_tap_install  "arthurk/homebrew-virt-manager" &&
#is_profile_admin_or_similar   &&  homebrew_brew_install      "virt-manager"
#is_profile_admin_or_similar   &&  homebrew_brew_install      "virt-viewer"         # QEMU Virt Manager/Viewer for macOS Monterey
is_profile_admin_or_similar   &&  homebrew_brew_tap_install  "boz/repo"            &&                                           homebrew_brew_install  "boz/repo/kail"   # kubernetes pods console viewer
#is_profile_admin_or_similar  &&  homebrew_brew_install      "tdsmith/ham/chirp"   # CHIRP software to configure HAM radios
#is_profile_admin_or_similar  &&  homebrew_brew_install      "tdsmith/ham/xastir"  # HAM Station Tracking / Info reporting
## GUI applications
#homebrew_brew_cask_workaround0
is_profile_admin_or_similar  &&  homebrew_brew_tap_install   "homebrew/cask"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "miniconda"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "google-chrome"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "vlc"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "jetbrains-toolbox"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "sketch"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "calibre"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "sourcetree"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "transmission"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "skype"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "dropbox"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "cyberduck"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "grandperspective"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "1password"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "onyx"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "postman"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "keka"               # File Archiver with support for zst,zip,etc
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "http-toolkit"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "textmate"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "trailer"            # Github Pull Requests Manager
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "intel-haxm"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "vnc-viewer"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "thinkorswim"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "spyder"             # Python/R datasciense IDE
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "zeplin"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "ngrok"
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "xquartz"            # X.Org X Window System
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "parsec"             # Local/Remote LAN stream
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "qlvideo"            # Additional supported format for Finder's  Quicklook
is_profile_admin_or_similar  &&  homebrew_brew_cask_install  "tableplus"          # DataGrip alternative, with NoSQL support, until DataGrip bring support

is_profile_admin  &&  homebrew_brew_tap_install "homebrew/autoupdate"             # Auto update homebrew packages every 1d
is_profile_adimn  &&  brew autoupdate start "86400" --uprade --cleanup 

# Google Cloud SDK 
shell_name="$( basename \"echo $SHELL\" )"
is_profile_admin_or_similar && homebrew_brew_cask_install "google-cloud-sdk" && \
	source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.${shell_name}.inc" && \
	gcloud components install alpha beta core gsutil bq cloud_sql_proxy datalab 

## Browser add-ons
pushd "$BOOSTRAP_DIR"
is_profile_admin_or_similar && $SHELL -x ../install/browsers/chrome/extensions/install.sh
is_profile_admin_or_similar && $SHELL -x ../install/browsers/firefox/extensions/install.sh
popd

is_profile_admin_or_similar  &&  pip3_global_install  "awscli"        # AWS command line
is_profile_admin_or_similar  &&  pip3_global_install  "buku[server]"  # Browser independent bookmark manager, with standalone server

# https://developer.apple.com/library/content/technotes/tn2459/_index.html
is_profile_admin_or_similar && todolist_add_new_entry "Allow Kernel extension from Intel XAM to run: System Preferences > Seucrity Privacy > General Tab > Allow button"

is_profile_admin_or_similar  &&  homebrew_brew_install  "mas"         #  Mac App Store command line too
is_profile_admin_or_similar  &&  homebrew_mas_install   "1451685025"  #  Wireguard
is_profile_admin_or_similar  &&  homebrew_mas_install   "539883307"   #  LINE Inc
is_profile_admin_or_similar  &&  homebrew_mas_install   "409203825"   #  Numbers
is_profile_admin_or_similar  &&  homebrew_mas_install   "409201541"   #  Pages
is_profile_admin_or_similar  &&  homebrew_mas_install   "1295203466"  #  Microsoft Remote Desktop
is_profile_admin_or_similar  &&  homebrew_mas_install   "1388020431"  #  DevCleaner For Xcode (remove simulator & associated caches)
[[ is_profile_admin || is_profile_dev_single || is_profile_dev_multi ]] && tmux_install_tpm

# Fixing git-crypt no visible in SourceTree
# src: https://jira.atlassian.com/browse/SRCTREE-2511?focusedCommentId=2835134&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-2835134
is_profile_admin_or_similar && echo "Fixing SourceTree not having git-crypt in its default path" && sudo ln -s /usr/local/bin/git-crypt /Applications/SourceTree.app/Contents/Resources/bin/

# Set OSX user/system defaults
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
$is_admin_available || message_info_show "Change Administrator password"
$is_admin_available || sudo ${SUDOERS_OPTIONS} passwd administrator

popd

message_info_show "Machine setup almost complete"
todolist_show_read_todolist

