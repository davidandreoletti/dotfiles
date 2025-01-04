## Command line applications
## - List of available packages
##  - http://braumeister.org/
##  - http://brewformulas.org/

if is_profile_admin_or_similar; then
    homebrew_brew_tap_install              "homebrew/services"  # Launch services in background.
    homebrew_brew_tap_install              "burntsushi/ripgrep"  "https://github.com/BurntSushi/ripgrep.git"
    homebrew_brew_tap_install              "boz/repo"
    #homebrew_brew_tap_install              "mopidy/mopidy"
    is_macos  &&  homebrew_brew_tap_install  "saulpw/vd"
    # Note: use standard ffmpeg due to it being a
    #       dependency of many other package (eg: modpidy, mpd, etc ...)
    #
    # FIXME: investigate how to install this package as keg-only,
    #        in addition to homebrew's provided ffmepg package
    #homebrew_brew_tap_install              "homebrew-ffmpeg/ffmpeg"

    #homebrew_brew_tap_install              "arthurk/homebrew-virt-manager"

    # Upgrade existing packages to avoid brew install failing
    # on outdated packages with a linking step, like 'python'
    homebrew_brew_upgrade

    # Python version for OS & utilities
    if ci_is_ci; then
        python_args="--overwrite"
    fi

    homebrew_brew_install    $python_args "python3" \
    &&  homebrew_brew_link   $python_args "python3" \
    &&  homebrew_postinstall               "python3"

    # Python global apps in virtual envs
    is_macos && homebrew_brew_install      "pipx"                   \
             && homebrew_brew_install      "__commit_aggregated__"  \
             && pipx ensurepath

    is_fedora && fedora_dnf_install        "pipx"                   \
              && fedora_dnf_install        "__commit_aggregated__"  \
              && pipx ensurepath

    is_archl && homebrew_brew_install      "pipx"                   \
             && homebrew_brew_install      "__commit_aggregated__"  \
             && pipx ensurepath

    # Python version manager
    homebrew_brew_install                  "pyenv"              # Manage python version on a per user/folder basis
    homebrew_brew_install                  "pyenv-virtualenv"   # pyenv plugin: virtualenv/venv
    is_fedora && fedora_dnf_install        "bzip2-devel"        # dependencies for pyenv installed python versions
    is_fedora && fedora_dnf_install        "sqlite-devel"       # dependencies for pyenv installed python versions
    is_fedora && fedora_dnf_install        "tk-devel"           # dependencies for pyenv installed python versions

    # Java version manager
    homebrew_brew_install                  "volta"              # Manage nodejs version on a per user/folder basis

    # Programing languages
    homebrew_brew_install                  "java"

    # Rust
    homebrew_brew_install                  "rust"                # Default Rust + package manager / compiler toolchain
    homebrew_brew_install                  "rustup"              # Tools to install other compiler toolchain / channels

    # Bash shell
    is_fedora && fedora_dnf_install        "bash"
    is_macos  && homebrew_brew_install     "bash"  &&  sudo  bash  -c  "echo  $(brew  --prefix)/bin/bash >> $SHELLS_FILE";
    is_archl  && homebrew_brew_install     "bash"

    # Symlink manager
    homebrew_brew_install                  "stow"              # Symlink manager

    # Git
    homebrew_brew_install                  "git"                # Get more recent version than the one shipped in Xcode
    homebrew_brew_install                  "gitui"              # git TUI for large patch set to deal with on a console
    homebrew_brew_install                  "lazygit"            # git TUI easy interactive rebase
    homebrew_brew_install                  "git-delta"          # Better diff output for git
    homebrew_brew_install                  "git-crypt"          # Encrypt git repository
    homebrew_brew_install                  "git-fixup"          # Automated "fixup!"" git commit creation
    homebrew_brew_install                  "git-absorb"         # Automated "fixup!"" git commit creation too
    is_fedora  &&  fedora_dnf_install      "git-credential-libsecret" # git credential helper using GNOME's libsecret backend
    is_fedora  &&  homebrew_brew_install   "git-credential-libsecret" # provide git credential helper with libsecret also for homebrew's installed git
    is_macos   &&  homebrew_brew_install   "shihanng/gig/gig"   # Generate .gitignore by programming language. dependency: fzf

    # Github
    homebrew_brew_install                  "gh"                 # Automated "fixup!"" git commit creation

    # Diff tools
    homebrew_brew_install                  "spaceman-diff"       # Git can now diff images as colourfull ASCII approximation
    homebrew_brew_install                  "difftastic"          # Langauge syntax aware diff

    # GNU * utils
    homebrew_brew_install                  "coreutils"          # Apple has outdated unix tooling.
    homebrew_brew_install                  "findutils"          # GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
    homebrew_brew_install                  "inetutils"          # GNU `ftp`, `sftp`
    homebrew_brew_install                  "gnu-sed"            # Apple has outdated unix tooling. sed is another one
    homebrew_brew_install                  "netcat"             # Apple has outdated unix tooling. netcat is one of them
    homebrew_brew_install                  "util-linux"         # Collection of linux utilies such as flock
    homebrew_brew_install                  "usbutils"           # List USB devices via lsusb
    homebrew_brew_install                  "moreutils"          # parallel, elekdo, etc
    homebrew_brew_install                  "gnu-sed"            # GNU `sed`, overwriting the built-in `sed`
    is_macos && homebrew_brew_install      "proctools"          # GNU pkill, pgrep
    homebrew_brew_install                  "inetutils"          # GNU ftp comand and more
    homebrew_brew_install                  "gnu-which"          # GNU which comand

    # Disk usage
    homebrew_brew_install                  "dua-cli"            # faster ncdu with interactive support

    # Zsh shell
    # Use as default shell for current user
    is_fedora && fedora_dnf_install        "zsh"
    is_macos  && homebrew_brew_install     "zsh" \
              && homebrew_brew_install     "__commit_aggregated__" \
              && sudo bash -c "echo $(brew --prefix)/bin/zsh >> $SHELLS_FILE" \
              && sudo chsh -s $(brew --prefix)/bin/zsh $USER;
    is_archl  && homebrew_brew_install     "zsh"
    homebrew_brew_install                  "tmux"
    homebrew_brew_install                  "vim"

    # Neovim
    # - neovim python package, neovim python bindings are installed by shellrc's neovim plugin
    homebrew_brew_install                  "neovim"

    # Local Large Language Model
    homebrew_brew_install                  "ollama"              # Fetch/Run Large Language Models locally

    # RSS
    homebrew_brew_install                  "newsboat"            # RSS/Atom reader

    # File synchronization
    homebrew_brew_install                  "rsync"

    # File explorer
    homebrew_brew_install                  "z"                   # Smarter cd
    homebrew_brew_install                  "zoxide"              # like z but better
    #homebrew_brew_install                  "xplr"                # File explorer with many integrations
    #homebrew_brew_install                  "nnn"                 # required by xplr
    homebrew_brew_install                  "yazi"                # Simpler xplr replacement

    # File size explorer
    homebrew_brew_install                  "ncdu"                # du TUI (aka Grandperspective for terminal)
    homebrew_brew_install                  "bat"                 # cat with highlighting, paging, line numbers support

    # File type detection
    homebrew_brew_install                  "file"

    # File encoding
    is_macos && homebrew_brew_install      "libiconv"            # Convert files from/to various character encodings

    # File renamer
    is_macos && homebrew_brew_install      "rename"              # Mass file rename

    # File progress
    homebrew_brew_install                  "progress"            # Report cp,mv,dd,tar,gzip,gunzip,cat's % of copied data

    # File deletion
    homebrew_brew_install                  "rm-improved"         # Undo rm operations -sometimes-

    # File listing color customization
    homebrew_brew_install                  "vivid"               # Customize LS_COLORS

    # Debugger
    if is_arch_x86_64; then
        homebrew_brew_install              "gdb"                 # versatile debugger
    fi

    # Email client
    homebrew_brew_install                  "aerc"
    homebrew_brew_install                  "himalaya"

    # IRC client
    homebrew_brew_install                  "irssi"               # IRC client. Note: --with-perl=yes --with-proxy included since brew irssi formula v1.2.3

    # Cron
    is_fedora && fedora_dnf_install        "cronie"              # crontab support

    # Programming language SDK manager
    homebrew_brew_install                  "jenv"                # Java JDK manager
    homebrew_brew_install                  "nvm"                 # Node SDK manager
    homebrew_brew_install                  "goenv"               # Golang environment manager
    homebrew_brew_install                  "asdf"                # Version manager for multiple runtime environment
    homebrew_brew_install                  "tfenv"               # Terraform version manager like rbenv
    is_macos  && homebrew_brew_install     "rbenv"               # Ruby Version Installer and manager
    is_fedora && fedora_dnf_install        "rbenv"
    is_archl  && archlinux_pacman_aur_install  "rbenv"

    # Clipboard management
    is_fedora && fedora_dnf_install        "xclip"               #
    is_fedora && fedora_dnf_install        "xsel"                #
    is_archl  && archlinux_pacman_install  "xclip"               #
    is_archl  && archlinux_pacman_install  "xsel"                #

    # Network data transfer
    homebrew_brew_install                  "wget"
    homebrew_brew_install                  "curl"
    homebrew_brew_install                  "httpie"              # Curl simplified
    homebrew_brew_install                  "tcpdump"             # TCP traffic sniffing

    # Network topology discovery
    homebrew_brew_install                  "nmap"                # Network Mapper

    # Network performance
    homebrew_brew_install                  "iperf3"              # Network performance measurement

    # Database/cache engines
    # - Redis
    homebrew_brew_install                  "redis"               # Redis Key-Value Storage
    # - Postgres
    homebrew_brew_install                  "pspg"                # Pager for psql official client

    # Multimedia tools
    homebrew_brew_install                  "fdk-aac"             # Fraunhofer FDK AAC library
    homebrew_brew_install                  "openssl"             # Openssl library
    homebrew_brew_install                  "libvmaf"             # VMAF brary
    homebrew_brew_install                  "jpeg-xl"             # JPEG-XL codec library
    homebrew_brew_install                  "zimg"                # Scaling, colorspace conversion, and dithering library

    #homebrew_brew_install                  "homebrew-ffmpeg/ffmpeg/ffmpeg \
    #                                        --with-fdk-aac \
    #                                        --with-openssl \
    #                                        --with-libvmaf \
    #                                        --with-jpeg-xl \
    #                                        --with-zimg"         # FFMPEG (using https://github.com/homebrew-ffmpeg/homebrew-ffmpeg's tap + dependencies above this line)

    # Multimedia players
    homebrew_brew_install                  "mpc"                 # Music player (CLI) client
    homebrew_brew_install                  "ncmpc"               # Music player (TUI) client

    # Multimedia servers
    homebrew_brew_install                  "mpd"                 # Music player daemon
    # - not using mopidy - prefer mpd
    if is_macos || is_fedora || is_archl; then
        # Wait for PR fix: https://github.com/mopidy/homebrew-mopidy/issues/44
        :
    else
        :
        #homebrew_brew_install                  "mopidy"              # Music server with cloud music support plugins
        #homebrew_brew_install                  "mopidy-mpd"          # Mopidi plugin to mpd clients
        #homebrew_brew_install                  "mopidy-local"        # Mopidi plugin to play local music
        #homebrew_brew_install                  "mopidy-somafm"       # Mopidi plugin to play somafm music
        #homebrew_brew_install                  "mopidy-soundcloud"   # Mopidi plugin to play soundcloud music
        #homebrew_brew_install                  "mopidy-spotify"      # Mopidi plugin to play spotify music
        #homebrew_brew_install                  "mopidy-tunein"       # Mopidi plugin to play tune-in music
    fi

    # Music download
    pipx_pipx_install                      "ytmdl"               # Youtube music downloader

    # Archive decompression
    homebrew_brew_install                  "unp"                 # Decompress anything
    homebrew_brew_install                  "ouch"                # Compress/decompress anything

    # Personal dashboard
    homebrew_brew_install                  "wtfutil"

    homebrew_brew_install                  "fzf"                 # Ctrl+R replacement for searching the history / files
    homebrew_brew_install                  "fd"                  # A simpler find

    # CLI cheatsheet
    homebrew_brew_install                  "tlrc"                # Short manpage version, with example for most comman use cases
                                                                 # tldr: python client
                                                                 # tlrc: rust client
    homebrew_brew_install                  "cheat"               # Alternative short manpage version, with example for most comman use cases
    homebrew_brew_install                  "navi"                # Execute one liner from cheatsheet

    # Local system monitoring
    homebrew_brew_install                  "htop"                #
    homebrew_brew_install                  "glances"             # Extensive system monitoring

    # OpenSSH client / server
    is_macos  &&  homebrew_brew_install    "openssh"             # OpenSSH client and server
    is_fedora &&  fedora_dnf_install       "openssh-server"  \
              &&  fedora_dnf_install "__commit_aggregated__" \
              &&  systemd_systemctl_enable sshd \
              &&  systemd_systemctl_start  sshd
    is_archl  &&  archlinux_pacman_install "openssh" \
              &&  archlinux_pacman_install "__commit_aggregated__" \
              &&  systemd_systemctl_enable sshd \
              &&  systemd_systemctl_start  sshd

    # Firewall port knocking
    #is_macos  &&  homebrew_brew_install    "fwknop"             # Disabled by brew upstream
    #is_fedora &&  fedora_dnf_install       "fwknop"

    # De/Encryption
    homebrew_brew_install                  "gnupg"               # GNU implementation of PGP
    homebrew_brew_install                  "hopenpgp-tools"      # Verify PGP key setup best practice
    is_macos && homebrew_brew_install      "pinentry-mac"        # Connect gpg-agent to OSX keychain
    is_fedora && fedora_dnf_install        "pinentry"            #
    is_archl && archlinux_pacman_install   "pinentry"            #
    homebrew_brew_install                  "pgpdump"             # PGP packet/key analyser
    homebrew_brew_install                  "age"                 # File encryption for the masses

	# Secret sharing
    homebrew_brew_install                  "ots"                 # Time bound secret sharing

    # Container setup: docker
    homebrew_brew_install                  "docker"                                 # Container runtime engine. No need for macOS's Docker Desktop
    homebrew_brew_install                  "docker-buildx"                          # BuildKit extension
    homebrew_brew_install                  "docker-credential-helper"               # docker login support
    homebrew_brew_install                  "lazydocker"                             # TUI docker

    # Container setup: colima
    homebrew_brew_install                  "colima"              # Container runtime engine

    # Container: any
    homebrew_brew_install                  "dive"                # Inspect docker layers

    # Kubernetes
    homebrew_brew_install                  "boz/repo/kail"       # kubernetes pods console viewer
    homebrew_brew_install                  "k9s"                 # kubernetes cluster manager TUI

	# Text characters
    homebrew_brew_install                  "chars"               # Display name/code for ASCII/Unicode characters/code points

    # Text manipulation
    homebrew_brew_install                  "gawk"                # Required by: tmux-fingers plugin

    # XML Manipulation/query
    homebrew_brew_install                  "xml-coreutils"       # Command XML utilities (eg: xml-grep)
    homebrew_brew_install                  "xmlstarlet"          # Command XML utilities (eg: xmlstarlet)

    # CSV Manipulation/query
    homebrew_brew_install                  "csvkit"              # Swiss army knife for csv files

    # JSON Manipulation/query
    homebrew_brew_install                  "jq"                  # JSON manipulator

    # YAML Manipulation/query
    homebrew_brew_install                  "python-yq"           # YAML manipulator. Requires: jq

    # Terminal browser
    homebrew_brew_install                  "lynx"                # Terminal browser

    # File sharing
    homebrew_brew_install                  "ffsend"              # Firefox Send client. Required by 1 oh-my-shell plugin

    # i18n
    homebrew_brew_install                  "translate-shell"     # Translate any languages

    # Calculator
    homebrew_brew_install                  "libqalculate"        # qalc: General pupose calculator, to convert unit / dimension analysis
    homebrew_brew_install                  "pcalc"               # palc: hex/binary/decimal calculator

    # QR code
    homebrew_brew_install                  "qrencode"            # Generae QR code

    # Linter
    homebrew_brew_install                  "shellcheck"          # Lint bash/zsh/sh scripts
    homebrew_brew_install                  "shfmt"               # Format bash/posix scripts

    # Wireguard
    homebrew_brew_install                  "wireguard-tools"     # Wireguard tooling. Eg: wg

    # Virtualization
    homebrew_brew_install                  "libvirt"             # KVM/Qemu machine definition / hypervision abstraction
    homebrew_brew_install                  "qemu"
    is_macos  && homebrew_brew_install     "virt-manager"        # QEMU Manager
    is_fedora && fedora_dnf_install        "virt-manager"
    is_archl  && archlinux_pacman_install  "virt-manager"

    # ISO
    homebrew_brew_install                  "xorriso"             # ISO9660+RR manipulation tool to kickstart a fedora vm with virt-install

    # Software defined radio
    #homebrew_brew_install                  "tdsmith/ham/xastir"  # HAM Station Tracking / Info reporting
    #homebrew_brew_install                  "tdsmith/ham/chirp"   # CHIRP software to configure HAM radios

    # Scrum
    # Daily standup manager
    # Task manager
    pipx_pipx_install                      "tasklog"             # Install tasklog cli
    homebrew_brew_install                  "task"                # Taskwarrior

    # AWS SDK
    if ci_is_ci; then
        # awscli dependes on python3.11 which
        # cannot be symlink to /usr/bin/2to3 witouth
        # error. Skipping dependencies for now
        awscli_args="--ignore-dependencies --overwrite"
    fi

    homebrew_brew_install   $awscli_args   "awscli"              # AWS CLI

    # Digital Ocean
    homebrew_brew_install                  "doctl"               # Digital Ocean CLI

    # Oracle Cloud SDK
    is_macos && homebrew_brew_install      "oci-cli"             # Oracle Cloud CLI

    # Timezone
    homebrew_brew_install                  "tz"                  # Timezone helper

    # Mastodon
    homebrew_brew_install                  "tut"                 # TUI mastodon client

    # Run command on event
    homebrew_brew_install                  "watch"               # Run a command at regular interval
    homebrew_brew_install                  "entr"                # Run command on files that have changed

    # Benchmarking
    homebrew_brew_install                  "hyperfine"           # benchmarking tool for CLI programs mostly

    # Image processing
    homebrew_brew_install                  "imagemagick"         # Required by spaceman-diff

    # Line oriented search tool
    homebrew_brew_install                  "ripgrep"             # faster grep "rigrep" binary compiled, as nightly build, and including SIMD and all optimizations enabled.

    # AST oriented search tool
    homebrew_brew_install                  "ast-grep"            # AST based code structural search
                                                                 # Required by VIM's fzf.vim plugin
    # Terminal Image protocol
    homebrew_brew_install                  "libsixel"            #

    # Search any kind of doc
    homebrew_brew_install                  "rga"                 # "rigrep" extended to most file formats: PDF, ebooks, office documents, zip, tar.gz, etc
    homebrew_brew_install                  "pandoc"              # required by 'rga'
    homebrew_brew_install                  "poppler"             # required by 'rga'

    # Source code search tool
    homebrew_brew_install                  "the_silver_searcher" # Faster than 'ack' file content search too

    # Keychain
    homebrew_brew_install                  "pass" 		         # Password storage

    # Shell prompt
    homebrew_brew_install                  "starship" 		     # Cross platfrom shell prompt

    # terminfo database
    is_fedora && fedora_dnf_install        "ncurses-term"        # ncurses v6.2+'s terminfo database with kitty/alacritty terminal support
    is_macos  && homebrew_brew_install     "ncurses" 		     # Starting with macOS Sonoma's built-in ncurses, kitty/alacritty terminal is supported
    is_archl  && archlinux_pacman_install  "ncurses"             # ncurses v6.2+'s terminfo database with kitty/alacritty terminal support

    is_macos  && homebrew_brew_install     "pcsc-lite"           # Smart card access middleware for SCard API (PC/SC)
    is_fedora && fedora_dnf_install        "pcsc-lite"
    is_archl  && archlinux_pacman_install  "pcsclite"
    #is_macos  && homebrew_brew_install     "pcsc-lite-ccid"      # Generic USB CCCID (Chip/Smart Card Interface Driver) and ICC (Integrated Circuit Interface driver)
    is_fedora && fedora_dnf_install        "pcsc-lite-ccid"
    is_archl  && archlinux_pacman_install  "ccid"
    #is_macos  && homebrew_brew_install     "pcsc-tools"          # Scan smart cards
    is_fedora && fedora_dnf_install        "pcsc-tools"

    is_fedora && systemd_systemctl_enable  "pcscd" \
              && systemd_systemctl_start   "pcscd"
    is_archl  && systemd_systemctl_enable  "pcsclite" \
              && systemd_systemctl_start   "pcsclite"

    # Tabular data
    is_macos  && homebrew_brew_install      "visidata"           # Visualize tabular data in the terminal
    is_fedora && fedora_dnf_install         "visidata"
    is_archl  && archlinux_pacman_install   "visidata"

    # Typing
    cargo_global_install                   "thokr"               # Typing tester

    # LLM client
    #                                                            # Lx: https://prompt.16x.engineer/blog/ai-coding-l1-l5
    homebrew_brew_install                  "aichat"              # L1: Code completion / question
    homebrew_brew_install                  "aider"               # L2: Task level completion / Ticket to code

    # Misc
    homebrew_brew_install                  "fortune"             # Fortune cookie
    homebrew_brew_install                  "jp2a"                # Convert images to ASCII. Required by spaceman-diff
    homebrew_brew_install                  "pv"                  # pipe data flow speed progress indicator
    homebrew_brew_install                  "pstree"              # Show ps output as a tree
    homebrew_brew_install                  "libfaketime"         # Freeze system clock for a given application (eg: shell script)
    homebrew_brew_install                  "expect"              # Automate interactive program interactions
    homebrew_brew_install                  "xdg-ninja"           # Recommands where to move files per program when programs support XDG directories structures
    homebrew_brew_install                  "tree"                # Print directory content as tree structure
    homebrew_brew_install                  "rlwrap"              # Needed to execute PlistBuddy in command mode
    homebrew_brew_install                  "ngrep"               # grep for network resource
    is_macos && homebrew_brew_install      "trash"               # Move files into macOS user's trash bin (as if done from the Finder)
    homebrew_brew_install                  "so"                  # Query stackoverflow TUI
    homebrew_brew_install                  "universal-ctags"     # catgs for vim's TagBar

    # Shell formatter
    homebrew_brew_install                  "shfmt"               # Shell script formatter

    # Matrix
    homebrew_brew_install                  "iamb"                # Matrix client CLI with vim bindings

    # UART/Serial terminal
    homebrew_brew_install                  "tio"                 # Simple UART terminal

    # K8s
    is_fedora &&  homebrew_brew_install    "kubectl"             # K8s client only
    is_archl  &&  homebrew_brew_install    "kubectl"

    is_fedora && fedora_dnf_install        "fuse3"               # Hardware smartcard requirements
    is_archl  && archlinux_pacman_install  "fuse3"
    is_fedora && fedora_dnf_install        "fuse3-devel"

    homebrew_brew_install                  "__commit_aggregated__"
    is_fedora && fedora_dnf_install        "__commit_aggregated__"
    is_archl  && archlinux_pacman_install  "__commit_aggregated__"
fi

if is_profile_admin; then
    is_macos && homebrew_brew_tap_install "homebrew/autoupdate"  # Auto update homebrew packages every 31d
    is_macos && brew autoupdate start "2678400" --upgrade --cleanup
fi

# Install (bash/zsh)-completions
if is_profile_admin_or_similar; then
    homebrew_brew_install                  "zsh-autosuggestions"
    homebrew_brew_install                  "zsh-autocomplete"

    homebrew_brew_install                  "zsh-completions"
    homebrew_brew_install                  "bash-completion@2"    # bash-completion support pre bash v4. bash-completion@2 support bash v4+

    homebrew_brew_install "__commit_aggregated__"
fi

if is_profile_admin || is_profile_dev_single || is_profile_dev_multi; then
    tmux_install_tpm
fi
