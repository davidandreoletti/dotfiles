## Command line applications
## - List of available packages
##  - http://braumeister.org/
##  - http://brewformulas.org/A

is_profile_admin_or_similar
if [ "$?" -eq 0 ];
then
    homebrew_brew_tap_install              "homebrew/services"  # Launch services in background.
    homebrew_brew_tap_install              "burntsushi/ripgrep"  "https://github.com/BurntSushi/ripgrep.git"
    homebrew_brew_tap_install              "boz/repo"
    #homebrew_brew_tap_install              "arthurk/homebrew-virt-manager"

    # Python version for OS & utilities
    homebrew_brew_install                  "python3" \
    &&  homebrew_brew_link                 "python3" \
    &&  homebrew_postinstall               "python3"	

    # Python version manager for development projects 
    homebrew_brew_install                  "pyenv"              # Manage python version on a per user/folder basis
    homebrew_brew_install                  "pyenv-virtualenv"   # pyenv plugin: virtualenv/venv
    is_fedora && fedora_dnf_install        "bzip2-devel"        # dependencies for pyenv installed python versions 
    is_fedora && fedora_dnf_install        "sqlite-devel"       # dependencies for pyenv installed python versions 
    is_fedora && fedora_dnf_install        "tk-devel"           # dependencies for pyenv installed python versions 
    
    is_fedora && fedora_dnf_install        "bash"
    is_macos  && homebrew_brew_install     "bash"  &&  sudo  bash  -c  "echo  $(brew  --prefix)/bin/bash >> $SHELLS_FILE";
    homebrew_brew_install                  "git"                # Get more recent version than the one shipped in Xcode
    homebrew_brew_install                  "coreutils"          # Apple has outdated unix tooling.
    homebrew_brew_install                  "findutils"          # GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
    homebrew_brew_install                  "gnu-sed"            # Apple has outdated unix tooling. sed is another one
    
    # Use as default shell for current user
    is_fedora && fedora_dnf_install        "zsh"
    is_macos  && homebrew_brew_install     "zsh"   && sudo bash -c "echo $(brew --prefix)/bin/zsh >> $SHELLS_FILE" && sudo chsh -s $(brew --prefix)/bin/zsh $USER;
    homebrew_brew_install                  "tmux"
    homebrew_brew_install                  "vim"
    
    # Install neovim, neovim python package, neovim python bindings package
    homebrew_brew_install                  "neovim"  \
    && pip3_global_install                 "neovim"  \
    && pip3_global_install                 "pynvim" 
    
    homebrew_brew_install                  "newsbeuter"
    homebrew_brew_install                  "rsync"
    homebrew_brew_install                  "gdb"                 # versatile debugger
    homebrew_brew_install                  "neomutt"
    homebrew_brew_install                  "jenv"
    homebrew_brew_install                  "htop"
    homebrew_brew_install                  "nvm"
    homebrew_brew_install                  "wget"
    homebrew_brew_install                  "goenv"               # Golang environment manager
    homebrew_brew_install                  "asdf"                # Version manager for multiple runtime environment
    homebrew_brew_install                  "util-linux"          # Collection of linux utilies
    homebrew_brew_install                  "redis"               # Redis Key Value Storage
    homebrew_brew_install                  "curl"
    homebrew_brew_install                  "mpd"                 # Music player daemon
    homebrew_brew_install                  "mpc"                 # Music player (simple) client
    homebrew_brew_install                  "pms"                 # Music player (tui) client
    homebrew_brew_install                  "unp"
    homebrew_brew_install                  "bat"                 # cat with highlighting, paging, line numbers support
    homebrew_brew_install                  "fzf"                 # Ctrl+R replacement for searching the history / files
    homebrew_brew_install                  "fd"                  # A simpler find
    homebrew_brew_install                  "tldr"                # Short manpage version, with example for most comman use cases
    homebrew_brew_install                  "ncdu"                #Replacement for Grandperspective and du
    homebrew_brew_install                  "openssh"             
    homebrew_brew_install                  "irssi"               # IRC client. Note: --with-perl=yes --with-proxy included since brew irssi formula v1.2.3
    homebrew_brew_install                  "rlwrap"              # Needed to execute PlistBuddy in command mode
    homebrew_brew_install                  "tcpdump"             # TCP traffic sniffing
    homebrew_brew_install                  "ngrep"               # grep for network resource

    homebrew_brew_install                  "ripgrep-bin"         # faster grep "rigrep" binary compiled, as nightly build, and including SIMD and all optimizations enabled.
    homebrew_brew_install                  "jq"                  # JSON manipulator
    homebrew_brew_install                  "python-yq"           # YAML manipulator. Requires: jq
    homebrew_brew_install                  "ack"                 # Fast file content search too
    homebrew_brew_install                  "trash"               # Move files into macOS user's trash bin (as if done from the Finder)
    homebrew_brew_install                  "entr"                # Run command on files that have changed
    homebrew_brew_install                  "spaceman-diff"       # Git can now diff images as colourfull ASCII approximation
    homebrew_brew_install                  "imagemagick"         # Required by spaceman-diff
    homebrew_brew_install                  "jp2a"                # Convert images to ASCII. Required by spaceman-diff
    homebrew_brew_install                  "hub"                 # Unofficial Github CLI (for Pull Requests, etc)
    homebrew_brew_install                  "z"                   # Smarter cd
    homebrew_brew_install                  "pv"                  # pipe data flow speed progress indicator
    homebrew_brew_install                  "dive"                # Inspect docker layers
    homebrew_brew_install                  "rename"              # Mass file rename
    homebrew_brew_install                  "moreutils"           # parallel, elekdo, etc
    homebrew_brew_install                  "mitmproxy"           # Charles Proxy in command line
    homebrew_brew_install                  "tree"
    homebrew_brew_install                  "gnu-sed"             # GNU `sed`, overwriting the built-in `sed`
    homebrew_brew_install                  "xml-coreutils"       # Command XML utilities (eg: xml-grep)
    homebrew_brew_install                  "xmlstarlet"          # Command XML utilities (eg: xmlstarlet)
    homebrew_brew_install                  "lynx"                # Terminal browser
    is_macos  && homebrew_brew_install     "rbenv"               # Ruby Version Installer and manager
    is_fedora && fedora_dnf_install        "rbenv"
    homebrew_brew_install                  "gawk"                # Required by: tmux-fingers plugin
    homebrew_brew_install                  "ffsend"              # Firefox Send client. Required by 1 oh-my-shell plugin
    homebrew_brew_install                  "csvkit"              # Swiss army knife for csv files
    homebrew_brew_install                  "libiconv"            # Convert files from/to various character encodings
    homebrew_brew_install                  "postgresql@14"       # Postgresql DB and standard command line utils like psql. PG db not started at runtime.
    homebrew_brew_install                  "pspg"                # Pager for psql official client
    homebrew_brew_install                  "proctools"           # GNU pkill, pgrep
    homebrew_brew_install                  "translate-shell"     # Translate any languages
    homebrew_brew_install                  "qrencode"            # Generae QR code
    homebrew_brew_install                  "httpie"              # Curl simplified
    homebrew_brew_install                  "libqalculate"        # qalc: General pupose calculator, to convert unit / dimension analysis
    homebrew_brew_install                  "rename"              # Mass rename files.
    homebrew_brew_install                  "shellcheck"          # Linting for bash/sh shells scripts
    homebrew_brew_install                  "gnupg"               # GNU implementation of PGP
    homebrew_brew_install                  "pinentry-mac"        # Connect gpg-agent to OSX keychain
    homebrew_brew_install                  "hopenpgp-tools"      # Verify PGP key setup best practice
    homebrew_brew_install                  "pgpdump"             # PGP packet/key analyser
    homebrew_brew_install                  "libfaketime"         # Freeze system clock for a given application (eg: shell script)
    homebrew_brew_install                  "expect"              # Automate interactive program interactions
    homebrew_brew_install                  "git-crypt"           # Encrypt git repository
    homebrew_brew_install                  "iperf3"              # Network performance measurement
    homebrew_brew_install                  "inetutils"           # GNU ftp comand and more
    homebrew_brew_install                  "wireguard-tools"     # Wireguard tooling. Eg: wg
    homebrew_brew_install                  "nmap"                # Network Mapper
    homebrew_brew_install                  "java"
    homebrew_brew_install                  "libvirt"             # KVM/Qemu machine definition / hypervision abstraction
    homebrew_brew_install                  "qemu"
    #homebrew_brew_install                  "virt-manager"
    #homebrew_brew_install                  "virt-viewer"         # QEMU Virt Manager/Viewer for macOS Monterey
    #homebrew_brew_install                  "tdsmith/ham/chirp"   # CHIRP software to configure HAM radios
    #homebrew_brew_install                  "tdsmith/ham/xastir"  # HAM Station Tracking / Info reporting
    homebrew_brew_install                  "boz/repo/kail"       # kubernetes pods console viewer
    pip3_global_install                    "buku[server]"        # Browser independent bookmark manager, with standalone server
    pip3_global_install                    "tasklog"             # Install tasklog cli
    pip3_global_install                    "awscli"              # AWS command line
fi

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
    fi

    is_fedora  &&  fedora_flatpak_remote_add               "flathub"     "https://flathub.org/repo/flathub.flatpakrepo"
    is_fedora  &&  fedora_flatpak_remote_add               "fedora"      "oci+https://registry.fedoraproject.org"
    is_fedora  &&  fedora_snap_install                     "snap-store"
    is_macos   &&  homebrew_brew_tap_install               "homebrew/cask"

    is_macos   &&  homebrew_brew_cask_install              "kitty"
    is_fedora  &&  fedora_dnf_install                      "kitty"
 
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



is_profile_admin
if [ "$?" -eq 0 ];
then
    homebrew_brew_tap_install "homebrew/autoupdate"  # Auto update homebrew packages every 1d
    brew autoupdate start "86400" --uprade --cleanup 
fi

# Install *-completions at the end to prevent the error below when installing other packages
#
# Error: Cannot install util-linux because conflicting formulae are installed.
#   bash-completion: because both install `mount`, `rfkill`, and `rtcwake` completions
#   rename: because both install `rename` binaries
# 
# Please `brew unlink bash-completion rename` before continuing.
# 
# Unlinking removes a formula's symlinks from /home/linuxbrew/.linuxbrew. You can
# link the formula again after the install finishes. You can --force this
# install, but the build may fail or cause obscure side effects in the
# resulting software.
is_profile_admin_or_similar
if [ "$?" -eq 0 ];
then
    homebrew_brew_install      "zsh-completions" \
    && homebrew_brew_install   "bash-completion"
fi

[[ is_profile_admin || is_profile_dev_single || is_profile_dev_multi ]] && tmux_install_tpm


