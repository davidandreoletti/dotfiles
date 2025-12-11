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
                    if sudo ${SUDO_OPTIONS} pacman --sync --refresh --sysupgrade --needed --noconfirm $(<"$pkgs_file") 2>"${stderr_file}"; then
                        rm -fv "$pkgs_file"
                        rm -fv "${retry_file}"
                        break
                    else
                        if test -f "${retry_file}"; then
                            cat "$stderr_file"
                            rm -fv "${retry_file}"
                            exit 1
                        else
                            cat "$stderr_file"
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
                if sudo ${SUDO_OPTIONS} pacman --sync --refresh --sysupgrade --needed --noconfirm $@ 2>"${stderr_file}"; then
                    rm -fv "$pkgs_file"
                    rm -fv "${retry_file}"
                    break
                else
                    if test -f "${retry_file}"; then
                        cat "$stderr_file"
                        exit 1
                    else
                        cat "$stderr_file"
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
    # Install an AUR package using paru (instead of invoking makepkg directly).
    # paru will clone the AUR repo, build / install the package + dependencies
    local pkg_name="$1"

    if ! command -v paru >/dev/null 2>&1; then
        echo "WARNING: paru AUR helper is not installed. Installing paru first." >&2
        local old_pkg_name="$pkg_name"
        pkg_name="paru"

        local pkg_dir="/tmp/aur/${pkg_name}"
        mkdir -p "$pkg_dir"
        pushd "$pkg_dir"
            if test -d "package.git"; then
                pushd "package.git"
                    : #git pull
                popd
            else
                git clone --depth=1 "https://aur.archlinux.org/${pkg_name}" "package.git"
                chmod -Rv 777 package.git
                if id "builduser" &>/dev/null; then
                    chown -Rv builduser:root package.git
                else
                    chown -Rv $USER:$USER package.git
                fi
                git config --global --add safe.directory '*'
            fi

            pushd "package.git"
                if id "builduser" &>/dev/null; then
                    sudo su - builduser -c "cd $pkg_dir/package.git; makepkg --syncdeps --install --noconfirm"
                    pacman --upgrade --needed --noconfirm *.pkg.tar.zst
                else
                    pushd $pkg_dir/package.git
                        makepkg --syncdeps --install --noconfirm
                        sudo pacman --upgrade --needed --noconfirm *.pkg.tar.zst
                    popd
                fi
            popd
        popd

        pkg_name="$old_pkg_name"
    fi

    message_info_show "paru install $pkg_name ..."

    # Prefer building as the dedicated AUR build user when it exists (e.g. in CI).
    if id "builduser" &>/dev/null; then
        sudo ${SUDO_OPTIONS} -u builduser paru -S --needed --noconfirm "$pkg_name"
    else
        paru -S --needed --noconfirm "$pkg_name"
    fi
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
