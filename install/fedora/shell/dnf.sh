###############################################################################
# Fedora's dnf package manager
###############################################################################

# param1: package name
fedora_dnf_install() {
    local pkgs_file="/tmp/bootstrap.$$.fedora.pkgs"
    local stderr_file="${pkgs_file}.stderr"
    local retry_file="${pkgs_file}.retry"

    if test ${HOMEBREW_BREW_INSTALL_AGGREGATED:-1} -eq 0; then
        local install_aggregated=0
    else
        local install_aggregated=1
    fi

    case "$1" in
       *'://'*) 
           # Package is a URL to probably a RPM file
           local pre_args1="__commit_aggregated__"
           ;;
    esac

    for args in $pre_args0 $pre_args1 "$@";
    do
        if test "$1" = "__commit_aggregated__"; then
            if test "$args" = "__commit_aggregated__"; then
                message_info_show "$pkgs_file install ..."
                while :;
                do
                    if sudo ${SUDO_OPTIONS} dnf -y install $(<"$pkgs_file") 2>"${stderr_file}"; then
                        rm -fv "$pkgs_file"
                        rm -fv "${retry_file}"
                        break
                    else
                        if test -f "${retry_file}"; then
                            rm -fv "${retry_file}"
                            exit 1
                        else
                            touch "${retry_file}"
                            continue
                        fi
                    fi
                done
            fi
        elif test $install_aggregated -eq 0; then
            message_info_show "$1 install delayed ..."
            echo -n " $@" >> "$pkgs_file"
        else
            message_info_show "$1 install ..."
            # Must use default sudo setting. Hence no: -u <user_name>

            while :;
            do
                if sudo ${SUDO_OPTIONS} dnf -y install $@ 2>"${stderr_file}"; then
                    rm -fv "$pkgs_file"
                    rm -fv "${retry_file}"
                    break
                else
                    if test -f "${retry_file}"; then
                        exit 1
                    else
                        touch "${retry_file}"
                        continue
                    fi
                fi
            done
        fi
    done
}

fedora_dnf_group_install() {
    message_info_show "$1 group install ..."
    # Must use default sudo setting. Hence no: -u <user_name>
    sudo ${SUDO_OPTIONS} dnf -y group install "$1"
}

fedora_dnf_update_repo_metadata() {
    message_info_show "Update repositories metadata..."
    sudo ${SUDO_OPTIONS} dnf upgrade --refresh -y
}

# param1: repo url 
fedora_dnf_config_manager_add_repo() {
    message_info_show "$1 repo to add ..."
    # Must use default sudo setting. Hence no: -u <user_name>
    sudo ${SUDO_OPTIONS} dnf -y config-manager --add-repo $@
}
