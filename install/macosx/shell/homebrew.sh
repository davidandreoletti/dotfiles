###############################################################################
# Homebrew related functions
###############################################################################

homebrew_is_installed() {
    which brew >> /dev/null
    return $?
}

homebrew_install() {
    message_info_show "brew package manager install ..."
    pushd /tmp
    echo -ne '\n' | sudo ${SUDO_OPTIONS} -u "$(whoami)" ${SUDO_OPTIONS} ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    popd
    # Check system is ready to install software via brew
    brew doctor
    return $?
}

# param1: package name
homebrew_brew_install() {
    message_info_show "$1 install ..."
    sudo ${SUDO_OPTIONS} -u "$(whoami)" brew install $@
}

homebrew_brew_linkapps() {
    message_info_show "brew linkapps ..."
    sudo ${SUDO_OPTIONS} -u "$(whoami)" brew linkapps
}

# param1: tapname
homebrew_brew_tap_install() {
    sudo ${SUDO_OPTIONS} -u "$(whoami)" brew tap "$1"
}

homebrew_brew_cask_workaround0() {
    # create dirs with right permission/wonership otherwise cask will
    # prompt for a password
    sudo ${SUDO_OPTIONS} -u "$(whoami)" mkdir -p "/opt/homebrew-cask/Caskroom" # FIXME permission denied
    # standard /opt dir permission/ownership
    sudo ${SUDO_OPTIONS} chmod 0775 "/opt"
    sudo ${SUDO_OPTIONS} chown "root:wheel" "/opt"
    # cask permission/ownership
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chmod 0755 "/opt/homebrew-cask"
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chmod 0755 "/opt/homebrew-cask/Caskroom"
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chown "$(whoami):staff" "/opt/homebrew-cask"
    sudo ${SUDO_OPTIONS} -u "$(whoami)" chown "$(whoami):staff" "/opt/homebrew-cask/Caskroom"
}

#param1: appname
homebrew_brew_cask_install() {
    sudo ${SUDO_OPTIONS} -u "$(whoami)" brew cask install "$1"
}
