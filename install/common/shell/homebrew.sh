###############################################################################
# Homebrew related functions
###############################################################################

homebrew_is_installed() {
    local brew_init="/tmp/brew_shell_env.sh"
    # case: macOs
    test -d /usr/local/Homebrew && eval "$(/usr/local/Homebrew/bin/brew shellenv)" > $brew_init && source $brew_init
    # case: linux
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)" > $brew_init && source $brew_init
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" > $brew_init && source $brew_init

    command -v brew >/dev/null 2>&1 /dev/null
}

homebrew_install() {
    # Install brew package manager
    pushd /tmp
	    echo -ne '\n' | sudo ${SUDO_OPTIONS} -u "$(whoami)" ${SUDO_OPTIONS} INTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    popd

    # Source brew shell init script
    local brew_init="/tmp/brew_shell_env.sh"
    # - case: macOs
    test -d /usr/local/Homebrew && eval "$(/usr/local/Homebrew/bin/brew shellenv)" > $brew_init && source $brew_init
    # - case: linux
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)" > $brew_init && source $brew_init
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" > $brew_init && source $brew_init
    rm -f $brew_init

    # Update shell PATH binary cache
    hash

    # Check system is ready to install software via brew
    brew doctor
}

homebrew_package_manager_install() {
    if homebrew_is_installed; then
	    # machine already boostraped 
	    :
    else
        message_info_show "Homebrew install ..."
        if ! homebrew_install; then #FIXME ask for password 
            message_error_show "failed"
	fi
        #homebrew_is_installed && is_profile_admin_or_similar && homebrew_fix_writable_dirs "$(whoami)"
    fi
}

homebrew_fix_writable_dirs() {
    local owner="$1"
    for dir_path in "/usr/local/Homebrew" "/usr/local/etc/bash_completion.d" "/usr/local/share/doc" "/usr/local/share/man" "/usr/local/share/man/man1" "/usr/local/share/zsh" "/usr/local/share/zsh/site-functions" "/usr/local/var/homebrew/locks";
    do
       sudo chown -R "$owner:admin" "$dir_path"
    done
}

# param1: package name
homebrew_brew_install() {
    local pkgs_file="/tmp/bootstrap.$$.brew.pkgs"
    local stderr_file="${pkgs_file}.stderr"

    brew=$(which brew)

    # Complex brew invocation requires immediate 
    # install of previsouly delayed packages
    if test $# -ge 2; then
       local pre_args0="__commit_aggregated__"	   
    fi

    if test ${HOMEBREW_BREW_INSTALL_AGGREGATED:-1} -eq 0; then
        local install_aggregated=0
    else
        local install_aggregated=1
    fi

    for args in $pre_args0 $pre_args1 "$@";
    do
        if test "$args" = "__commit_aggregated__"; then
            if test -f "$pkgs_file"; then
                while :; 
                do
                    message_info_show "$pkgs_file install ..."
                    sudo ${SUDO_OPTIONS} -u "$(whoami)" $brew install $(<"$pkgs_file") 2>${stderr_file}
                    local exit_code=$?
                    if test $exit_code -eq 0; then
                        rm -fv "$pkgs_file"
                        break
                    else
                       if grep "Too many open files" "$stderr_file"; then
                           message_warning_show "restart install due to transcient error"
                           continue
                       else
                          cat "$stderr_file"
                          exit $exit_code
                       fi
                    fi
                done
            fi
        elif test $install_aggregated -eq 0; then
            message_info_show "$1 install delayed ..."
            echo -n " $@" >> "$pkgs_file"
        else
            message_info_show "$1 install ..."
            sudo ${SUDO_OPTIONS} -u "$(whoami)" $brew install $@
        fi
    done
}

homebrew_postinstall() {
    homebrew_brew_install "__commit_aggregated__"

    message_info_show "$1 post install ..."
    brew=$(which brew)
    sudo ${SUDO_OPTIONS} -u "$(whoami)" $brew postinstall $@
}

homebrew_brew_linkapps() {
    message_info_show "brew linkapps ..."
    brew=$(which brew)
    sudo ${SUDO_OPTIONS} -u "$(whoami)" $brew linkapps
}

homebrew_brew_link() {
    homebrew_brew_install "__commit_aggregated__"

    message_info_show "brew link $@ ..."
    brew=$(which brew)
    sudo ${SUDO_OPTIONS} -u "$(whoami)" $brew link $@
}

homebrew_brew_upgrade() {
    brew=$(which brew)

    local stderr_file="/tmp/$$.brew.upgrade.stderr"

    while :; 
    do
        message_info_show "brew upgrade ..."
        if sudo ${SUDO_OPTIONS} -u "$(whoami)" $brew upgrade 2>${stderr_file}; then
            break
        else
            if grep "Too many open files" "$stderr_file"; then
                message_warning_show "restart install due to transcient error"
                continue
            else
                cat "$stderr_file"
                exit 1
            fi
        fi
    done
}

# param1: tapname
# param2: tapSourceURL
homebrew_brew_tap_install() {
    brew=$(which brew)
    sudo ${SUDO_OPTIONS} -u "$(whoami)" $brew tap "$1" $2
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
    local pkgs_file="/tmp/bootstrap.$$.brew.casks"

    if test ${HOMEBREW_BREW_INSTALL_AGGREGATED:-1} -eq 0; then
        local install_aggregated=0
    else
        local install_aggregated=1
    fi

    brew=$(which brew)

    for args in $pre_args0 $pre_args1 "$@";
    do
        if test "$args" = "__commit_aggregated__"; then
            if test -f "$pkgs_file"; then
                message_info_show "$pkgs_file install ..."
                sudo ${SUDO_OPTIONS} -u "$(whoami)" $brew install $(<"$pkgs_file")
                rm -fv "$pkgs_file"
            fi
        elif test $install_aggregated -eq 0; then
            message_info_show "$1 install delayed ..."
            echo -n " $@" >> "$pkgs_file"
        else
            message_info_show "$1 install ..."
	    sudo ${SUDO_OPTIONS} -u "$(whoami)" $brew install --cask "$@"
        fi
    done
}

# param1: package name
homebrew_mas_install() {
    message_info_show "$1 install ..."
    mas=$(which mas)
    sudo ${SUDO_OPTIONS} -u "$(whoami)" $mas install $@
}


