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
    :
#    set -x
#    
#    DSCL='/usr/bin/dscl'
#
#    # Group name to add standard users to
#    # This group name will be used in place where homebrew expects the "admin" group
#    HOMEBREW_ADMIN_GROUP="admins"
#
#    # Create new homebrew admin group
#    sudo ${SUDO_OPTIONS} $DSCL . read /Groups/${HOMEBREW_ADMIN_GROUP}  || sudo ${SUDO_OPTIONS} $DSCL . create /Groups/${HOMEBREW_ADMIN_GROUP}
#
#    # Add current user to the group
#    #staffGroupId=`dscl . -read /Groups/staff | awk '($1 == "PrimaryGroupID:") { print $2 }'`
#    #dscl . -list /Users PrimaryGroupID | grep " ${staffGroujpId}$"
#    sudo ${SUDO_OPTIONS} /usr/sbin/dseditgroup -o edit -n /Local/Default -a $(whoami) -t user ${HOMEBREW_ADMIN_GROUP}
#    
#    #Switch homebrew managed group permission folders for multi users brew install usage
#    #src: https://gitlab.com/alyda/dotfiles/snippets/19654
#    sudo ${SUDO_OPTIONS} /usr/sbin/chown -R :${HOMEBREW_ADMIN_GROUP} /usr/local/*
#    sudo ${SUDO_OPTIONS} /bin/chmod -R g+w /usr/local/*
#    sudo ${SUDO_OPTIONS} /usr/sbin/chown -R :${HOMEBREW_ADMIN_GROUP} /Library/Caches/Homebrew 
#    sudo ${SUDO_OPTIONS} /bin/chmod -R g+w /Library/Caches/Homebrew 
#    sudo ${SUDO_OPTIONS} /bin/mkdir -p /opt
#    sudo ${SUDO_OPTIONS} /bin/chmod 0755 /opt
#    sudo ${SUDO_OPTIONS} /usr/sbin/chown "root:wheel" /opt
#    sudo ${SUDO_OPTIONS} /usr/sbin/chown -R :${HOMEBREW_ADMIN_GROUP} /opt
#    sudo ${SUDO_OPTIONS} /bin/chmod -R g+w /opt 
#    set +x
}

#param1: appname
homebrew_brew_cask_install() {
    sudo ${SUDO_OPTIONS} -u "$(whoami)" brew cask install "$1"
}

# param1: package name
homebrew_mas_install() {
    message_info_show "$1 install ..."
    sudo ${SUDO_OPTIONS} -u "$(whoami)" mas install $@
}


