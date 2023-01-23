## GUI applications
is_profile_admin_or_similar
if [ "$?" -eq 0 ];
then

    is_fedora
    if [ "$?" -eq 0 ];
    then
        # Add Anaconda repository
        # src: https://docs.conda.io/projects/conda/en/latest/user-guide/install/rpm-debian.html
        # Import GPG public key
        rpm --import https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc

	    cat <<-EOF > /etc/yum.repos.d/conda.repo
		[conda]
		name=Conda
		baseurl=https://repo.anaconda.com/pkgs/misc/rpmrepo/conda
		enabled=1
		gpgcheck=1
		gpgkey=https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc
		EOF

        # Add RPM Fusion (free / nonfree)
        fedora_dnf_install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
        fedora_dnf_install "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    fi

    is_fedora  &&  fedora_flatpak_remote_add               "flathub"     "https://flathub.org/repo/flathub.flatpakrepo"
    is_fedora  &&  fedora_flatpak_remote_add               "fedora"      "oci+https://registry.fedoraproject.org"
    is_fedora  &&  fedora_snap_install                     "snap-store"
    is_macos   &&  homebrew_brew_tap_install               "homebrew/cask"

    is_macos   &&  homebrew_brew_cask_install              "kitty"
    is_fedora  &&  fedora_dnf_install                      "kitty"

    # Docker repository (from upstream rather than distribution packages)
    # src:
    #  - fedora: 
    #  -- https://docs.docker.com/engine/install/fedora/#install-using-the-repository
    #  -- https://docs.docker.com/engine/install/linux-postinstall/
    is_fedora  &&  fedora_dnf_config_manager_add_repo      "https://download.docker.com/linux/fedora/docker-ce.repo"
    is_fedora  &&  fedora_dnf_install                      "docker-ce" \
               &&  fedora_dnf_install                      "docker-ce-cli" \
               &&  fedora_dnf_install                      "containerd.io" \
               &&  fedora_dnf_install                      "docker-compose-plugin"
               &&  sudo usermod -a -G docker $(whoami) \
               &&  newgrp docker \
               &&  sudo systemctl enable docker.service \
               &&  sudo systemctl start docker.service
    is_macos   &&  echo "FIXME: Install docker-desktop (required) with https://docs.docker.com/desktop/install/mac-install/#install-from-the-command-line. Then automate the installation"

    is_macos   &&  homebrew_brew_cask_install              "miniconda"
    is_fedora  &&  fedora_dnf_install                      "conda"  && (echo "Install conda shell profiles"; sudo conda init --quiet)
    is_macos   &&  homebrew_brew_cask_install              "google-chrome"
    is_fedora  &&  fedora_flatpak_flathub_install          "com.google.Chrome"
    is_macos   &&  homebrew_brew_cask_install              "vlc"
    is_fedora  &&  fedora_flatpak_flathub_install          "org.videolan.VLC"
    is_macos   &&  homebrew_brew_cask_install              "utm"                  # Qemu GUI
    is_macos   &&  homebrew_brew_cask_install              "jetbrains-toolbox"
    is_fedora  &&  bash_command_curl                       "https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/0fdc2d6d94cc87d57170b0edde49d46ba4731504/jetbrains-toolbox.sh"
    is_macos   &&  homebrew_brew_cask_install              "calibre"
    is_fedora  &&  fedora_flatpak_flathub_install          "com.calibre_ebook.calibre"
    is_macos   &&  homebrew_brew_cask_install              "sourcetree"
    is_fedora  &&  fedora_dnf_install                      "gitg"
    is_macos   &&  homebrew_brew_cask_install              "transmission"
    is_fedora  &&  fedora_flatpak_flathub_install          "com.transmissionbt.Transmission"
    is_macos   &&  homebrew_brew_cask_install              "dropbox"
    is_fedora  &&  fedora_flatpak_flathub_install          "com.dropbox.Client"
    is_macos   &&  homebrew_brew_cask_install              "cyberduck"
    is_fedora  &&  fedora_flatpak_flathub_install          "org.filezillaproject.Filezilla"
    is_macos   &&  homebrew_brew_cask_install              "grandperspective"   # Disk usage GUI
    is_macos   &&  homebrew_brew_cask_install              "1password"
    is_macos   &&  homebrew_brew_cask_install              "onyx"
    is_macos   &&  homebrew_brew_cask_install              "postman"
    is_fedora  &&  fedora_flatpak_flathub_install          "com.getpostman.Postman"
    is_macos   &&  homebrew_brew_cask_install              "keka"               # File Archiver with support for zst,zip,etc
    is_fedora  &&  fedora_dnf_install                      "p7zip" \
               &&  fedora_dnf install                      "7zip-plugins"
    is_macos   &&  homebrew_brew_cask_install              "http-toolkit"
    is_macos   &&  homebrew_brew_cask_install              "textmate"
    is_fedora  &&  fedora_dnf_install                      "gedit"
    is_macos   &&  homebrew_brew_cask_install              "trailer"            # Github Pull Requests Manager
    is_macos   &&  homebrew_brew_cask_install              "vnc-viewer"
    is_fedora  &&  fedora_flatpak_flathub_install          "org.remmina.Remmina" 
    is_macos   &&  homebrew_brew_cask_install              "thinkorswim"
    is_fedora  &&  bash_command_curl                       "https://mediaserver.thinkorswim.com/installer/InstFiles/thinkorswim_installer.sh"
    #is_macos   &&  homebrew_brew_cask_install              "spyder"             # Python/R datasciense IDE
    #is_fedora  &&  fedora_dnf_install                      "python3-spyder"
    is_macos   &&  homebrew_brew_cask_install              "saulpw/vd/visidata" # Visualize tabular data in the terminal
    is_fedora  &&  fedora_dnf_install                      "visidata"
    is_macos   &&  homebrew_brew_cask_install              "ngrok"
    is_fedora  &&  fedora_snap_install                     "ngrok"
    is_macos   &&  homebrew_brew_cask_install              "xquartz"            # X.Org X Window System
    is_macos   &&  homebrew_brew_cask_install              "parsec"             # Local/Remote LAN stream
    is_macos   &&  homebrew_brew_cask_install              "qlvideo"            # Additional supported format for Finder's  Quicklook
    is_macos   &&  homebrew_brew_cask_install              "rar"                # RAR files

    is_macos   &&  homebrew_brew_cask_install              "google-earth-pro"   # Google Earth
    is_macos   &&  homebrew_brew_cask_install              "google-cloud-sdk" \
               &&  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.$(basename \"echo $SHELL\").inc" \
               &&  gcloud components install alpha beta core gsutil bq cloud_sql_proxy datalab 
    is_macos   &&  homebrew_brew_install                   "mas"         #  Mac App Store command line too
    is_macos   &&  homebrew_mas_install                    "1451685025"  #  Wireguard
    is_macos   &&  homebrew_mas_install                    "539883307"   #  LINE Inc
    is_macos   &&  homebrew_mas_install                    "409203825"   #  Numbers
    is_macos   &&  homebrew_mas_install                    "409201541"   #  Pages
    is_macos   &&  homebrew_mas_install                    "1295203466"  #  Microsoft Remote Desktop
    is_macos   &&  homebrew_mas_install                    "1388020431"  #  DevCleaner For Xcode (remove simulator & associated caches)
fi


