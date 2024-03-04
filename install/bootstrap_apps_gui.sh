app_disabled() {
    return 1
}

## GUI applications
if is_profile_admin_or_similar; then

    if is_fedora; then
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

        # Cloudflare WARP client
        # src: https://community.cloudflare.com/t/setup-warp-in-fedora-34/277475/7
        # src: https://linuxspin.com/install-and-configure-cloudflare-warp-on-linux/#install-cloudflare-warp-on-fedora
        rpm -ivh http://pkg.cloudflareclient.com/cloudflare-release-el8.rpm
        sed -i 's/dists\/\$releasever\/main/dists/8/main/' /etc/yum.repos.d/cloudflare.repo

        # Tailscale
        sudo dnf config-manager --add-repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

        # VSCode
        # src: https://code.visualstudio.com/docs/setup/linux
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

        # Google Cloud SDK
        sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
        [google-cloud-cli]
        name=Google Cloud CLI
        baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
        enabled=1
        gpgcheck=1
        repo_gpgcheck=0
        gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
        EOM
	# Google Chrome
	# src: https://docs.fedoraproject.org/en-US/quick-docs/installing-chromium-or-google-chrome-browsers
	fedora_dnf_install "fedora-workstation-repositories" \
	&& sudo dnf config-manager --set-enabled google-chrome
    fi

    # Alternative stores
    is_fedora  &&  fedora_flatpak_remote_add               "flathub"     "https://flathub.org/repo/flathub.flatpakrepo"
    is_fedora  &&  fedora_flatpak_remote_add               "fedora"      "oci+https://registry.fedoraproject.org"

    is_macos   &&  homebrew_brew_tap_install               "homebrew/cask"        \
               &&  homebrew_brew_tap_install              "__commit_aggregated__"

    # Terminal
    is_macos   &&  homebrew_brew_cask_install              "kitty"
    is_fedora  &&  fedora_dnf_install                      "kitty"
    is_macos   &&  homebrew_brew_cask_install              "alacritty"
    is_fedora  &&  fedora_dnf_install                      "alacritty"

    # Docker repository 
    # - from upstream rather than distribution packages
    # src:
    #  - fedora: 
    #  -- https://docs.docker.com/engine/install/fedora/#install-using-the-repository
    #  -- https://docs.docker.com/engine/install/linux-postinstall/
    is_fedora  &&  fedora_dnf_install                      "docker-ce"             \
               &&  fedora_dnf_install                      "docker-ce-cli"         \
               &&  fedora_dnf_install                      "containerd.io"         \
               &&  fedora_dnf_install                      "docker-compose-plugin" \
               &&  fedora_dnf_install                      "__commit_aggregated__" \
               &&  sudo usermod -a -G docker $(whoami)                             \
               &&  sudo systemctl enable docker.service                            \
               &&  sudo systemctl start docker.service
    is_macos   &&  echo "FIXME: Install docker-desktop (required) with https://docs.docker.com/desktop/install/mac-install/#install-from-the-command-line. Then automate the installation"

    # Anaconda
    is_macos   &&  homebrew_brew_cask_install              "miniconda"
    #is_fedora  &&  fedora_dnf_install                      "conda"                  \
    #           &&  fedora_dnf_install                      "__commit_aggregated__"  \
    #           && (echo "Install conda shell profiles"; sudo conda init --quiet)

    # Browser
    is_macos   &&  homebrew_brew_cask_install              "google-chrome"
    is_fedora  &&  fedora_dnf_install                      "google-chrome-beta"
    is_macos   &&  homebrew_brew_cask_install               "firefox"
    is_fedora  &&  fedora_dnf_install                      "firefox"

    # Video player
    is_macos   &&  homebrew_brew_cask_install              "vlc"
    is_fedora  &&  fedora_dnf_install                      "vlc"

    # Virtualization
    is_macos   &&  homebrew_brew_cask_install              "utm"                  # Qemu GUI

    # IDE
    is_macos   &&  homebrew_brew_cask_install              "jetbrains-toolbox"
    is_fedora  &&  bash_command_curl_no_sudo               "https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/20c25238c4c1c5a2f1807c200ac3a68e4d1cd3c3/jetbrains-toolbox.sh"

    # Books
    is_macos   &&  homebrew_brew_cask_install              "calibre"
    is_fedora  &&  fedora_dnf_install                      "calibre"

    # Torrent
    is_macos   &&  homebrew_brew_cask_install              "transmission"
    is_fedora  &&  fedora_dnf_install                      "transmission"

    # File transfer
    is_macos   &&  homebrew_brew_cask_install              "dropbox"
    is_fedora  &&  fedora_dnf_install                      "dropbox"
    is_macos   &&  homebrew_brew_cask_install              "cyberduck"
    is_fedora  &&  fedora_dnf_install                      "filezilla"
    is_macos   &&  homebrew_brew_cask_install              "grandperspective"   # Disk usage GUI

    # Password manager
    is_macos   &&  homebrew_brew_cask_install              "1password"
    is_macos   &&  homebrew_brew_cask_install              "keepassxc"
    is_fedora  &&  fedora_dnf_install                      "keepassxc"
    is_macos   &&  homebrew_brew_cask_install              "onyx"

    # Postman
    is_macos   &&  homebrew_brew_cask_install              "postman"
    is_fedora  &&  fedora_flatpak_flathub_install          "com.getpostman.Postman"
    # Archive
    is_macos   &&  homebrew_brew_cask_install              "keka"               # File Archiver with support for zst,zip,etc
    is_fedora  &&  fedora_dnf_install                      "p7zip" \
               &&  fedora_dnf_install                      "p7zip-plugins"
    is_macos   &&  homebrew_brew_cask_install              "rar"                # RAR files

    # HTTP forgery
    is_macos   &&  homebrew_brew_cask_install              "http-toolkit"
    # Text editor
    is_macos   &&  homebrew_brew_cask_install              "textmate"
    is_macos   &&  homebrew_brew_cask_install              "trailer"            # Github Pull Requests Manager
    # Remote desktop
    is_macos   &&  homebrew_brew_cask_install              "vnc-viewer"
    is_fedora  &&  fedora_dnf_install                      "remmina"
    is_macos   &&  homebrew_brew_cask_install              "parsec"             # Local/Remote LAN stream

    # ToS
    is_macos   &&  homebrew_brew_cask_install              "thinkorswim"
    is_fedora  &&  app_disabled && bash_command_curl       "https://mediaserver.thinkorswim.com/installer/InstFiles/thinkorswim_installer.sh"

    # Data Science
    #is_macos   &&  homebrew_brew_cask_install              "spyder"             # Python/R datasciense IDE
    #is_fedora  &&  fedora_dnf_install                      "python3-spyder"

    # Tabular data
    is_macos   &&  homebrew_brew_cask_install              "saulpw/vd/visidata" # Visualize tabular data in the terminal
    is_fedora  &&  fedora_dnf_install                      "visidata"

    # X11
    is_macos   &&  homebrew_brew_cask_install              "xquartz"            # X.Org X Window System

    is_macos   &&  homebrew_brew_cask_install              "qlvideo"            # Additional supported format for Finder's  Quicklook


    # VSCode
    #is_macos   &&  homebrew_brew_cask_install              "visual-studio-code"
    #is_fedora  &&  fedora_dnf_install                      "code"

    # Ngrok
    is_macos   &&  homebrew_brew_cask_install              "ngrok"
    #is_fedora  &&  fedora_snap_install                     "ngrok"

    # Cloudflare-WARP
    is_macos   &&  homebrew_brew_cask_install              "cloudflare-warp"    # Cloudflare WARP client
    is_fedora  &&  fedora_dnf_install                      "cloudflare-warp"

    # Tailscale
    is_macos   &&  homebrew_brew_cask_install              "tailscale"         # Tailscale client
    is_fedora  &&  fedora_dnf_install                      "tailscale"             \
               &&  fedora_dnf_install                      "__commit_aggregated__" \
               &&  sudo systemctl enable --now tailscaled

    # Geography
    is_macos   &&  homebrew_brew_cask_install              "google-earth-pro"   # Google Earth

    # Google Cloud SDK
    is_macos   &&  homebrew_brew_cask_install              "google-cloud-sdk"       \
               &&  homebrew_brew_cask_install              "__commit_aggregated__"  \
               &&  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.$(basename \"echo $SHELL\").inc" \
               &&  gcloud components install alpha beta core gsutil bq cloud_sql_proxy datalab 
    is_fedora  &&  fedora_dnf_install                      "google-cloud-cli"

    # Traffic shaping
    is_macos   &&  homebrew_brew_cask_install              "mitmproxy"           # Charles Proxy in command line

    is_fedora  &&  fedora_dnf_install                      "__commit_aggregated__"

    is_macos   &&  homebrew_brew_install                   "mas"         #  Mac App Store command line too
    is_macos   &&  homebrew_mas_install                    "1451685025"  #  Wireguard
    is_macos   &&  homebrew_mas_install                    "539883307"   #  LINE Inc
    is_macos   &&  homebrew_mas_install                    "409203825"   #  Numbers
    is_macos   &&  homebrew_mas_install                    "409201541"   #  Pages
    is_macos   &&  homebrew_mas_install                    "1295203466"  #  Microsoft Remote Desktop
    is_macos   &&  homebrew_mas_install                    "1388020431"  #  DevCleaner For Xcode (remove simulator & associated caches)
fi

