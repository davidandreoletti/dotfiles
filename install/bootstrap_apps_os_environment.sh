# OS environment

if is_profile_admin_or_similar; then
    if qemu_is_running; then
        :
        #is_cli_priority "critical" && is_archl  && archlinux_pacman_aur_install  ""
    fi
fi

