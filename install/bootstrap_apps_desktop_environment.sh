## Desktop environments
if is_profile_admin_or_similar; then
    # NVIDA drivers support
    is_fedora  &&  fedora_dnf_install "fedora-workstation-repositories"
    is_archl   &&  archlinux_pacman_install "nvidia-open" \
               &&  archlinux_pacman_install "nvidia-open-dkms" \
    # Non Fedora Core packages support
    # src: https://rpmfusion.org/FAQ#What_packages_are_available_from_RPM_Fusion.3F
    is_fedora  &&  fedora_dnf_install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    is_fedora  &&  fedora_dnf_install "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
               &&  fedora_dnf_update_repo_metadata \
               &&  fedora_dnf_install "rpmfusion-free-release-tainted" \
               &&  fedora_dnf_install "rpmfusion-nonfree-release-tainted"

    is_fedora  &&  fedora_dnf_install "__commit_aggregated__"

    # Gnome shell Desktop enviroment
    # - required package for minimal gnome desktop
    is_fedora  &&  fedora_dnf_install "gdm"
    is_archl   &&  archlinux_pacman_install "gdm"
    is_fedora  &&  fedora_dnf_install "gnome-shell"
    is_archl   &&  archlinux_pacman_install "gnome-shell"
    is_fedora  &&  fedora_dnf_install "gnome-terminal"
    is_archl   &&  archlinux_pacman_install "gnome-terminal"
    is_fedora  &&  fedora_dnf_install "__commit_aggregated__"
    is_archl   &&  archlinux_pacman_install "__commit_aggregated__"

    # Enable login using graphical interface
    is_fedora  &&  sudo ${SUDO_OPTIONS} systemctl enable gdm;
    is_archl   &&  sudo ${SUDO_OPTIONS} systemctl enable gdm;
    # Boot to graphical interface as default
    is_fedora  &&  sudo ${SUDO_OPTIONS} systemctl set-default graphical.target;
    is_archl   &&  sudo ${SUDO_OPTIONS} systemctl set-default graphical.target;

    # File Manager
    is_fedora  &&  fedora_dnf_install "nautilus"
    is_archl   &&  archlinux_pacman_install "nautilus"
    is_fedora  &&  fedora_dnf_install "gvfs"
    is_archl   &&  archlinux_pacman_install "gvfs"
    is_fedora  &&  fedora_dnf_install "gvfs-smb"
    is_archl   &&  archlinux_pacman_install "gvfs-smb"
    is_fedora  &&  fedora_dnf_install "gvfs-fuse"
    is_archl   &&  archlinux_pacman_install "gvfs-fuse"
    # - show user directories in file manager side bar
    is_fedora  &&  fedora_dnf_install "xdg-user-dirs"
    is_archl   &&  archlinux_pacman_install "xdg-user-dirs"
    is_fedora  &&  fedora_dnf_install "xdg-user-dirs-gtk"
    is_archl   &&  archlinux_pacman_install "xdg-user-dirs-gtk"
    # - show thumbnails per media types
    is_fedora  &&  fedora_dnf_install "ffmpegthumbnailer"
    is_archl   &&  archlinux_pacman_install "ffmpegthumbnailer"
    is_fedora  &&  fedora_dnf_install "evince-thumbnailer"
    is_archl   &&  archlinux_pacman_install "evince"
    # - manage compressed archives
    is_fedora  &&  fedora_dnf_install "file-roller-nautilus"

    # Keychain
    is_fedora  &&  fedora_dnf_install "seahorse"
    is_archl   &&  archlinux_pacman_install "seahorse"

    # Wallpaper
    is_fedora  &&  fedora_dnf_install "variety"
    is_archl   &&  archlinux_pacman_install "variety"

    # USB-IP
    is_fedora  &&  fedora_dnf_install "usbip"
    is_archl   &&  archlinux_pacman_install "usbip"
    is_fedora  &&  fedora_dnf_install "__commit_aggregated__"
    is_archl   &&  archlinux_pacman_install "__commit_aggregated__"
    is_fedora  &&  sudo ${SUDO_OPTIONS} systemctl enable "usbip-client"
    is_fedora  &&  sudo ${SUDO_OPTIONS} systemctl enable "usbip-server"
    is_archl   &&  sudo ${SUDO_OPTIONS} systemctl enable "usbipd"

    true
fi
