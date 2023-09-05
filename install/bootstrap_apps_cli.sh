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
    homebrew_brew_tap_install              "mopidy/mopidy"
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
    
    # Neovim, neovim python package, neovim python bindings package
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
    homebrew_brew_install                  "util-linux"          # Collection of linux utilies such as flock
    homebrew_brew_install                  "redis"               # Redis Key Value Storage
    homebrew_brew_install                  "fortune"             # Fortune cookie
    homebrew_brew_install                  "curl"
    homebrew_brew_install                  "mpd"                 # Music player daemon
    homebrew_brew_install                  "mpc"                 # Music player (simple) client
    homebrew_brew_install                  "pms"                 # Music player (tui) client
    homebrew_brew_install                  "mopidy"              # Music server with cloud music support plugins
    homebrew_brew_install                  "mopidy-mpd"          # Mopidi plugin to mpd clients
    homebrew_brew_install                  "mopidy-local"        # Mopidi plugin to play local music
    homebrew_brew_install                  "mopidy-somafm"       # Mopidi plugin to play somafm music
    homebrew_brew_install                  "mopidy-soundcloud"   # Mopidi plugin to play soundcloud music
    homebrew_brew_install                  "mopidy-spotify"      # Mopidi plugin to play spotify music
    homebrew_brew_install                  "mopidy-tunein"       # Mopidi plugin to play tune-in music
    homebrew_brew_install                  "unp"
    homebrew_brew_install                  "bat"                 # cat with highlighting, paging, line numbers support
    homebrew_brew_install                  "fzf"                 # Ctrl+R replacement for searching the history / files
    homebrew_brew_install                  "fd"                  # A simpler find
    homebrew_brew_install                  "tldr"                # Short manpage version, with example for most comman use cases
    homebrew_brew_install                  "ncdu"                #Replacement for Grandperspective and du

    # OpenSSH client / server
    homebrew_brew_install                  "openssh"             # OpenSSH client and server
    is_macos  &&  fedora_dnf_install       "openssh-server" \
              &&  sudo systemctl enable sshd \
              &&  sudo systemctl start sshd

    is_macos  &&  homebrew_brew_install    "fwknop"              # Firewall port knocking 
    is_fedora &&  fedora_dnf_install       "fwknop"

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

    is_fedora  &&  fedora_dnf_install      "git-credential-libsecret" # git credential helper using GNOME's libsecret backend
    is_fedora  &&  homebrew_brew_install   "git-credential-libsecret" # provide git credential helper with libsecret also for homebrew's installed git 

    homebrew_brew_install                  "imagemagick"         # Required by spaceman-diff
    homebrew_brew_install                  "jp2a"                # Convert images to ASCII. Required by spaceman-diff
    homebrew_brew_install                  "hub"                 # Unofficial Github CLI (for Pull Requests, etc)
    homebrew_brew_install                  "z"                   # Smarter cd
    homebrew_brew_install                  "pv"                  # pipe data flow speed progress indicator
    homebrew_brew_install                  "dive"                # Inspect docker layers
    homebrew_brew_install                  "rename"              # Mass file rename
    homebrew_brew_install                  "moreutils"           # parallel, elekdo, etc
    homebrew_brew_install                  "mitmproxy"           # Charles Proxy in command line
    homebrew_brew_install                  "xdg-ninja"           # Recommands where to move files per program when programs support XDG directories structures
    homebrew_brew_install                  "tree"                # Print directory content as tree structure 
    homebrew_brew_install                  "gnu-sed"             # GNU `sed`, overwriting the built-in `sed`
    homebrew_brew_install                  "xml-coreutils"       # Command XML utilities (eg: xml-grep)
    homebrew_brew_install                  "xmlstarlet"          # Command XML utilities (eg: xmlstarlet)
    homebrew_brew_install                  "lynx"                # Terminal browser
    is_macos  && homebrew_brew_install     "rbenv"               # Ruby Version Installer and manager
    is_fedora && fedora_dnf_install        "rbenv"
    homebrew_brew_install                  "gawk"                # Required by: tmux-fingers plugin
    homebrew_brew_install                  "ffsend"              # Firefox Send client. Required by 1 oh-my-shell plugin
    is_macos  && hhomebrew_brew_install    "csvkit"              # Swiss army knife for csv files
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
    homebrew_brew_install                  "pstree"              # Show ps output as a tree
    homebrew_brew_install                  "libfaketime"         # Freeze system clock for a given application (eg: shell script)
    homebrew_brew_install                  "expect"              # Automate interactive program interactions
    homebrew_brew_install                  "git-crypt"           # Encrypt git repository
    homebrew_brew_install                  "iperf3"              # Network performance measurement
    homebrew_brew_install                  "inetutils"           # GNU ftp comand and more
    homebrew_brew_install                  "wireguard-tools"     # Wireguard tooling. Eg: wg
    homebrew_brew_install                  "rust"                # Rust + package manager / compiler toolchain
    homebrew_brew_install                  "nmap"                # Network Mapper
    homebrew_brew_install                  "java"
    homebrew_brew_install                  "libvirt"             # KVM/Qemu machine definition / hypervision abstraction
    homebrew_brew_install                  "qemu"
    homebrew_brew_install                  "virt-manager"        # QEMU Manager
    homebrew_brew_install                  "xorriso"             # ISO9660+RR manipulation tool to kickstart a fedora vm with virt-install

    #homebrew_brew_install                  "virt-viewer"         # QEMU Virt Manager/Viewer for macOS Monterey
    #homebrew_brew_install                  "tdsmith/ham/chirp"   # CHIRP software to configure HAM radios
    #homebrew_brew_install                  "tdsmith/ham/xastir"  # HAM Station Tracking / Info reporting
    homebrew_brew_install                  "boz/repo/kail"       # kubernetes pods console viewer
    pip3_global_install                    "buku[server]"        # Browser independent bookmark manager, with standalone server
    pip3_global_install                    "tasklog"             # Install tasklog cli
    pip3_global_install                    "awscli"              # AWS CLI
    is_macos && homebrew_brew_install      "oci-cli"             # Oracle Cloud CLI
    homebrew_brew_install                  "tfenv"               # Terraform version manager like rbenv
fi

is_profile_admin
if [ "$?" -eq 0 ];
then
    homebrew_brew_tap_install "homebrew/autoupdate"  # Auto update homebrew packages every 1d
    brew autoupdate start "86400" --upgrade --cleanup 
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

