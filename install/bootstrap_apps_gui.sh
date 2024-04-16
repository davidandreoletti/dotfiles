app_disabled() {
    return 1
}

## GUI applications
if is_profile_admin_or_similar; then

    if is_fedora; then
        # Install missing DNF plugins core
        fedora_dnf_install "dnf-plugins-core"
        fedora_dnf_install "__commit_aggregated__"

        # Add Anaconda repository
        # src: https://docs.conda.io/projects/conda/en/latest/user-guide/install/rpm-debian.html
        # Import GPG public key
        sudo rpm --import https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc

		sudo tee -a /etc/yum.repos.d/conda.repo <<-EOF
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
	    fedora_dnf_config_manager_add_repo "https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo"

        # Tailscale
        fedora_dnf_config_manager_add_repo "https://pkgs.tailscale.com/stable/fedora/tailscale.repo"

        # VSCode
        # src: https://code.visualstudio.com/docs/setup/linux
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

        # Google Cloud SDK
		sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo <<-EOM
		[google-cloud-cli]
		name=Google Cloud CLI
		baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
		enabled=1
		gpgcheck=1
		repo_gpgcheck=0
		gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
		EOM

        # Docker
        fedora_dnf_config_manager_add_repo      "https://download.docker.com/linux/fedora/docker-ce.repo"

	    # Google Chrome
	    # src: https://docs.fedoraproject.org/en-US/quick-docs/installing-chromium-or-google-chrome-browsers
	    fedora_dnf_install "fedora-workstation-repositories" \
	    && sudo dnf config-manager --set-enabled google-chrome
    fi

    # Alternative stores
    is_fedora  &&  fedora_flatpak_remote_add               "flathub"     "https://flathub.org/repo/flathub.flatpakrepo"
    is_fedora  &&  fedora_flatpak_remote_add               "fedora"      "oci+https://registry.fedoraproject.org"

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
               &&  systemd_systemctl_enable docker.service                            \
               &&  systemd_systemctl_start docker.service
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
    #is_fedora  &&  fedora_dnf_install                      "filezilla"         # Filezilla may have adware. Never install this https://en.wikipedia.org/wiki/FileZilla#Bundled_adware_issues

    # Disk usage
    is_macos   &&  homebrew_brew_cask_install              "grandperspective"   # Disk usage GUI

    # Password manager
    is_macos   &&  homebrew_brew_cask_install              "1password"
    is_macos   &&  homebrew_brew_cask_install              "keepassxc"
    is_fedora  &&  fedora_dnf_install                      "keepassxc"
    is_macos   &&  homebrew_brew_cask_install              "onyx"

    # REST Client
    # FIXME: Replace postman

    # Archive
    is_macos   &&  homebrew_brew_cask_install              "keka"               # File Archiver with support for zst,zip,etc
    is_fedora  &&  fedora_dnf_install                      "p7zip" \
               &&  fedora_dnf_install                      "p7zip-plugins"
    is_macos   &&  homebrew_brew_cask_install              "rar"                # RAR files

    # HTTP forgery
    is_macos   &&  homebrew_brew_cask_install              "http-toolkit"

    # Text editor
    is_macos   &&  homebrew_brew_cask_install              "textmate"

    # Remote desktop
    is_macos   &&  homebrew_brew_cask_install              "tiger-vnc"
    is_fedora  &&  fedora_dnf_install                      "remmina"
    is_macos   &&  homebrew_brew_cask_install              "parsec"             # Local/Remote LAN stream

    # ToS
    is_macos   &&  homebrew_brew_cask_install              "thinkorswim"
    is_fedora  &&  app_disabled && bash_command_curl       "https://mediaserver.thinkorswim.com/installer/InstFiles/thinkorswim_installer.sh"

    # Data Science
    #is_macos   &&  homebrew_brew_cask_install              "spyder"             # Python/R datasciense IDE
    #is_fedora  &&  fedora_dnf_install                      "python3-spyder"

    # Tabular data
    is_macos   &&  homebrew_brew_tap_install               "saulpw/vd/visidata" \
               &&  homebrew_brew_cask_install              "saulpw/vd/visidata" # Visualize tabular data in the terminal
    is_fedora  &&  fedora_dnf_install                      "visidata"

    # X11
    is_macos   &&  homebrew_brew_cask_install              "xquartz"            # X.Org X Window System

    is_macos   &&  homebrew_brew_cask_install              "qlvideo"            # Additional supported format for Finder's  Quicklook


    # VSCode
    is_macos   &&  homebrew_brew_cask_install              "visual-studio-code" \ 
               &&  homebrew_brew_cask_install              "__commit_aggregated__"
    is_fedora  &&  fedora_dnf_install                      "code" \
               &&  fedora_dnf_install                      "__commit_aggregated__"

    # VSCode Extensions
    vscode_install_extension                               "ms-vscode-remote.remote-ssh" # Remote SSH Extension: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh
    vscode_install_extension                               "eamodio.gitlens"             # Git Explorater Extension
    vscode_install_extension                               "ms-python.python"            # Python Extension
    vscode_install_extension                               "donjayamanne.python-environment-manager"            # Python Virtual Env manager Extension
    vscode_install_extension                               "ms-toolsai.jupyter"          # Jupyter Extension
    vscode_install_extension                               "ms-toolsai.datawrangler"     # Data wrangler for Jupyter Notebook
    vscode_install_extension                               "ms-azuretools.vscode-docker" # Docker Extension
    vscode_install_extension                               "continue.continue"           # LLM autopilot
    vscode_install_extension                               "vscodevim.vim"               # VIM extension

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
               &&  systemd_systemctl_enable --now tailscaled

    # Geography
    is_macos   &&  homebrew_brew_cask_install              "google-earth-pro"   # Google Earth

    # Google Cloud SDK
    if ci_is_ci; then
        # google-cloud-sdk rely on non default python version.
        # Bug: it fails to link 2to3
        :
    else
        is_macos   &&  homebrew_brew_cask_install          "google-cloud-sdk"       \
                   &&  homebrew_brew_cask_install          "__commit_aggregated__"  \
                   &&  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.$(basename \"echo $SHELL\").inc" \
                   &&  gcloud components install alpha beta core gsutil bq cloud_sql_proxy datalab
    fi
    is_fedora  &&  fedora_dnf_install                      "google-cloud-cli"

    # Traffic shaping
    is_macos   &&  homebrew_brew_cask_install              "mitmproxy"           # Charles Proxy in command line

    is_macos   &&  homebrew_brew_cask_install              "__commit_aggregated__"
    is_fedora  &&  fedora_dnf_install                      "__commit_aggregated__"

    is_macos   &&  homebrew_brew_install                   "mas"         #  Mac App Store command line too
    is_macos   &&  homebrew_brew_install                   "__commit_aggregated__"
    is_macos   &&  homebrew_mas_install                    "1451685025"  #  Wireguard
    is_macos   &&  homebrew_mas_install                    "539883307"   #  LINE Inc
    is_macos   &&  homebrew_mas_install                    "409203825"   #  Numbers
    is_macos   &&  homebrew_mas_install                    "409201541"   #  Pages
    is_macos   &&  homebrew_mas_install                    "1295203466"  #  Microsoft Remote Desktop
    is_macos   &&  homebrew_mas_install                    "1388020431"  #  DevCleaner For Xcode (remove simulator & associated caches)
fi
