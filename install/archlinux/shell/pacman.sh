###############################################################################
# ArchLinux's pacman package manager
###############################################################################

# param1: package name
archlinux_pacman_install() {
    local pkgs_file="/tmp/bootstrap.$$.archlinux.pkgs"
    local stderr_file="${pkgs_file}.stderr"
    local retry_file="${pkgs_file}.retry"

    if test ${ARCHLINUX_PACMAN_INSTALL_AGGREGATED:-1} -eq 0; then
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
                    if sudo ${SUDO_OPTIONS} pacman --sync --refresh --sysupgrade --noconfirm $(<"$pkgs_file") 2>"${stderr_file}"; then
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
                if sudo ${SUDO_OPTIONS} pacman --sync --refresh --sysupgrade --noconfirm $@ 2>"${stderr_file}"; then
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

# param1: package name
archlinux_pacman_aur_install() {
    # https://wiki.archlinux.org/title/Arch_User_Repository#Prerequisites
    local pkg_name="$1"
    local pkg_dir="/tmp/aur/${pkg_name}"

    mkdir -p "$pkg_dir"
    pushd "$pkg_dir"
        git clone --depth=1 "https://aur.archlinux.org/${pkg_name}" "package.git"
        pushd "package.git"
            chmod -R 777 .
            git config --global --add safe.directory $PWD
            ls -alh ./
            sudo su - builduser -c "cd $pkg_dir/package.git; makepkg --syncdeps --install --noconfirm"
            ls -alh ./
            pacman -U *.pkg.tar.zst
        popd
    popd
}

archlinux_pacman_update_repo_metadata() {
    message_info_show "Update repositories metadata..."
    sudo ${SUDO_OPTIONS} pacman --sync --refresh
}

# param1: repo url
#archlinux_pacman_config_manager_add_repo() {
#    message_info_show "$1 repo to add ..."
#    # Must use default sudo setting. Hence no: -u <user_name>
#    sudo ${SUDO_OPTIONS} dnf -y config-manager --add-repo $@
#}
