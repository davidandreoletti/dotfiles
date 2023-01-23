## Desktop environments
is_profile_admin_or_similar
if [ "$?" -eq 0 ];
then
    # NVIDA drivers support
    is_fedora  &&  fedora_dnf_install "fedora-workstation-repositories"
    # Non Fedora Core packages support
    # src: https://rpmfusion.org/FAQ#What_packages_are_available_from_RPM_Fusion.3F
    is_fedora  &&  fedora_dnf_install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    is_fedora  &&  fedora_dnf_install "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
               &&  fedora_dnf_update_repo_metadata \
               &&  fedora_dnf_install "rpmfusion-free-release-tainted" \
               &&  fedora_dnf_install "rpmfusion-nonfree-release-tainted"


    # Gnome shell Desktop enviroment
    # - required package for minimal gnome desktop
    is_fedora  &&  fedora_dnf_install "gdm"
    is_fedora  &&  fedora_dnf_install "gnome-shell"
    is_fedora  &&  fedora_dnf_install "gnome-terminal"

    # Enable login using graphical interface
    is_fedora  &&  sudo ${SUDO_OPTIONS} systemctl enable gdm; 
    # Boot to graphical interface as default
    is_fedora  &&  sudo ${SUDO_OPTIONS} systemctl set-default graphical.target; 

    # File Manager
    is_fedora  &&  fedora_dnf_install "nautilus"
    # - show user directories in file manager side bar
    is_fedora  &&  fedora_dnf_install "xdg-user-dirs"
    is_fedora  &&  fedora_dnf_install "xdg-user-dirs-gtk"
    # - show thumbnails per media types
    is_fedora  &&  fedora_dnf_install "ffmpegthumbnailer"
    is_fedora  &&  fedora_dnf_install "evince-thumbnailer"
    # - manage compressed archives
    is_fedora  &&  fedora_dnf_install "file-roller-nautilus"

    # Keychain
    is_fedora  &&  fedora_dnf_install "seahorse"

    # Wallpaper
    is_fedora  &&  fedora_dnf_install "variety"
fi
