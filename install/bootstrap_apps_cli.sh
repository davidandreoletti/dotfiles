## Command line applications
## - List of available packages
##  - http://braumeister.org/
##  - http://brewformulas.org/

if is_profile_admin_or_similar; then
    homebrew_brew_tap_install              "burntsushi/ripgrep"  "https://github.com/BurntSushi/ripgrep.git"
    homebrew_brew_tap_install              "boz/repo"
    homebrew_brew_tap_install              "quickemu-project/quickemu" "https://github.com/quickemu-project/quickemu"
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

    # Install paru
    if is_archl; then
        archlinux_pacman_install "base-devel"
        git clone https://aur.archlinux.org/paru.git /tmp/paru-bin
        cd /tmp/paru-bin
            makepkg --syncdeps --install --noconfirm
        cd -
    fi

    is_cli_priority "critical" && homebrew_brew_install    $python_args "python3" \
    &&  homebrew_brew_link   $python_args "python3" \
    &&  homebrew_postinstall               "python3"

    # Python global apps in virtual envs
    is_cli_priority "critical" && is_macos && homebrew_brew_install      "pipx"                   \
             && homebrew_brew_install      "__commit_aggregated__"  \
             && pipx ensurepath

    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "pipx"                   \
              && fedora_dnf_install        "__commit_aggregated__"  \
              && pipx ensurepath

    is_cli_priority "critical" && is_archl && homebrew_brew_install      "pipx"                   \
             && homebrew_brew_install      "__commit_aggregated__"  \
             && pipx ensurepath

    # Python version manager
    is_cli_priority "critical" && homebrew_brew_install                  "pyenv"              # Manage python version on a per user/folder basis
    is_cli_priority "critical" && homebrew_brew_install                  "pyenv-virtualenv"   # pyenv plugin: virtualenv/venv
    is_cli_priority "critical" && homebrew_brew_install                  "uv"                 # Faster python version manager
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "bzip2-devel"        # dependencies for pyenv installed python versions
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "sqlite-devel"       # dependencies for pyenv installed python versions
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "tk-devel"           # dependencies for pyenv installed python versions

    # Java version manager
    is_cli_priority "critical" && homebrew_brew_install                  "volta"              # Manage nodejs version on a per user/folder basis

    # Programing languages
    is_cli_priority "critical" && homebrew_brew_install                  "java"

    # Rust
    is_cli_priority "critical" && homebrew_brew_install                  "rust"                # Default Rust + package manager / compiler toolchain
    is_cli_priority "critical" && homebrew_brew_install                  "rustup"              # Tools to install other compiler toolchain / channels

    # Bash shell
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "bash"
    is_cli_priority "critical" && is_macos  && homebrew_brew_install     "bash"  &&  sudo  bash  -c  "echo  $(brew  --prefix)/bin/bash >> $SHELLS_FILE";
    is_cli_priority "critical" && is_archl  && homebrew_brew_install     "bash"

    # Symlink manager
    is_cli_priority "critical" && homebrew_brew_install                  "stow"              # Symlink manager

    # Git
    is_cli_priority "critical" && homebrew_brew_install                  "git"                # Get more recent version than the one shipped in Xcode
    is_cli_priority "critical" && homebrew_brew_install                  "gitui"              # git TUI for large patch set to deal with on a console
    is_cli_priority "critical" && homebrew_brew_install                  "lazygit"            # git TUI easy interactive rebase
    is_cli_priority "critical" && homebrew_brew_install                  "tig"                # git text mode
    is_cli_priority "critical" && homebrew_brew_install                  "git-delta"          # Better diff output for git
    is_cli_priority "critical" && homebrew_brew_install                  "git-crypt"          # Encrypt git repository
    is_cli_priority "critical" && homebrew_brew_install                  "git-fixup"          # Automated "fixup!"" git commit creation
    is_cli_priority "critical" && homebrew_brew_install                  "git-absorb"         # Automated "fixup!"" git commit creation too
    is_cli_priority "critical" && is_fedora  &&  fedora_dnf_install      "git-credential-libsecret" # git credential helper using GNOME's libsecret backend
    is_cli_priority "critical" && is_fedora  &&  homebrew_brew_install   "git-credential-libsecret" # provide git credential helper with libsecret also for homebrew's installed git
    is_cli_priority "critical" && is_macos   &&  homebrew_brew_install   "shihanng/gig/gig"   # Generate .gitignore by programming language. dependency: fzf

    # Github
    is_cli_priority "optional" && homebrew_brew_install                  "gh"                 # Automated "fixup!"" git commit creation

    # Diff tools
    is_cli_priority "critical" && homebrew_brew_install                  "spaceman-diff"       # Git can now diff images as colourfull ASCII approximation
    is_cli_priority "critical" && homebrew_brew_install                  "difftastic"          # Langauge syntax aware diff

    # GNU * utils
    is_cli_priority "critical" && homebrew_brew_install                  "coreutils"          # Apple has outdated unix tooling.
    is_cli_priority "critical" && homebrew_brew_install                  "findutils"          # GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
    is_cli_priority "critical" && homebrew_brew_install                  "inetutils"          # GNU `ftp`, `sftp`
    is_cli_priority "critical" && homebrew_brew_install                  "gnu-sed"            # Apple has outdated unix tooling. sed is another one
    is_cli_priority "critical" && homebrew_brew_install                  "netcat"             # Apple has outdated unix tooling. netcat is one of them
    is_cli_priority "critical" && homebrew_brew_install                  "util-linux"         # Collection of linux utilies such as flock
    is_cli_priority "critical" && homebrew_brew_install                  "usbutils"           # List USB devices via lsusb
    is_cli_priority "critical" && homebrew_brew_install                  "moreutils"          # parallel, elekdo, etc
    is_cli_priority "critical" && homebrew_brew_install                  "gnu-sed"            # GNU `sed`, overwriting the built-in `sed`
    is_cli_priority "critical" && is_macos && homebrew_brew_install      "proctools"          # GNU pkill, pgrep
    is_cli_priority "critical" && homebrew_brew_install                  "inetutils"          # GNU ftp comand and more
    is_cli_priority "critical" && homebrew_brew_install                  "gnu-which"          # GNU which comand

    # S3 compatible File transfer
    is_cli_priority "optional" && homebrew_brew_install                  "duck"               # CLI companion to Cyberduck

    # Zsh shell
    # Use as default shell for current user
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "zsh"
    is_cli_priority "critical" && is_macos  && homebrew_brew_install     "zsh" \
              && homebrew_brew_install     "__commit_aggregated__" \
              && sudo bash -c "echo $(brew --prefix)/bin/zsh >> $SHELLS_FILE" \
              && sudo chsh -s $(brew --prefix)/bin/zsh $USER;
    is_cli_priority "critical" && is_archl  && homebrew_brew_install     "zsh"
    is_cli_priority "critical" && homebrew_brew_install                  "tmux"
    is_cli_priority "critical" && homebrew_brew_install                  "vim"

    # Neovim
    # - neovim python package, neovim python bindings are installed by shellrc's neovim plugin
    is_cli_priority "critical" && homebrew_brew_install                  "neovim"

    # Local Large Language Model
    is_cli_priority "optional" && homebrew_brew_install                  "ollama"              # Fetch/Run Large Language Models locally

    # RSS
    is_cli_priority "optional" && homebrew_brew_install                  "newsboat"            # RSS/Atom reader

    # File synchronization
    is_cli_priority "optional" && homebrew_brew_install                  "rsync"

    # File explorer
    is_cli_priority "critical" && homebrew_brew_install                  "z"                   # Smarter cd
    is_cli_priority "critical" && homebrew_brew_install                  "zoxide"              # like z but better
    is_cli_priority "optional" && homebrew_brew_install                  "yazi"                # Simpler xplr replacement

    # File size explorer
    is_cli_priority "optional" && homebrew_brew_install                  "dua-cli"             # faster ncdu with interactive support
    is_cli_priority "optional" && homebrew_brew_install                  "ncdu"                # du TUI (aka Grandperspective for terminal)

    is_cli_priority "critical" && homebrew_brew_install                  "bat"                 # cat with highlighting, paging, line numbers support

    # File type detection
    is_cli_priority "critical" && homebrew_brew_install                  "file"

    # File encoding
    is_cli_priority "critical" && is_macos && homebrew_brew_install      "libiconv"            # Convert files from/to various character encodings

    # File renamer
    is_cli_priority "critical" && is_macos && homebrew_brew_install      "rename"              # Mass file rename

    # File progress
    is_cli_priority "optional" && homebrew_brew_install                  "progress"            # Report cp,mv,dd,tar,gzip,gunzip,cat's % of copied data

    # LSP servers
    is_cli_priority "optional" && homebrew_brew_install                  "yaml-language-server"            # YAML support

    # File deletion
    is_cli_priority "critical" && homebrew_brew_install                  "rm-improved"         # Undo rm operations -sometimes-

    # File listing color customization
    is_cli_priority "critical" && homebrew_brew_install                  "vivid"               # Customize LS_COLORS

    # Disk performance
    is_cli_priority "optional" && homebrew_brew_install                  "fio"

    # Debugger
    if is_arch_x86_64; then
        is_cli_priority "optional" && homebrew_brew_install              "gdb"                 # versatile debugger
    fi

    # Email client
    is_cli_priority "optional" && homebrew_brew_install                  "aerc"
    is_cli_priority "optional" && homebrew_brew_install                  "himalaya"

    # Email filter
    is_cli_priority "optional" && homebrew_brew_install                  "imapfilter"          # Run filters to move/delete emails on remote email servers

    # Email backend
    is_cli_priority "optional" && homebrew_brew_install                  "isync"               # Sync Maildir to IMAP server

    # Email tooling
    #is_cli_priority "optional" && homebrew_brew_install                  "gmailctl"            # Modify Gmail filters with CLI

    # IRC client
    is_cli_priority "optional" && homebrew_brew_install                  "irssi"               # IRC client. Note: --with-perl=yes --with-proxy included since brew irssi formula v1.2.3

    # Cron
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "cronie"              # crontab support
    is_cli_priority "critical" && is_archl && archlinux_pacman_install   "cronie"

    # Programming language SDK manager
    is_cli_priority "critical" && homebrew_brew_install                  "jenv"                # Java JDK manager
    is_cli_priority "critical" && homebrew_brew_install                  "nvm"                 # Node SDK manager
    is_cli_priority "critical" && homebrew_brew_install                  "goenv"               # Golang environment manager
    is_cli_priority "critical" && homebrew_brew_install                  "asdf"                # Version manager for multiple runtime environment
    is_cli_priority "critical" && homebrew_brew_install                  "tfenv"               # Terraform version manager like rbenv
    is_cli_priority "critical" && is_macos  && homebrew_brew_install     "rbenv"               # Ruby Version Installer and manager
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "rbenv"
    is_cli_priority "critical" && is_archl  && archlinux_pacman_aur_install  "rbenv"

    # Clipboard management
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "xclip"               #
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "xsel"                #
    is_cli_priority "critical" && is_archl  && archlinux_pacman_install  "xclip"               #
    is_cli_priority "critical" && is_archl  && archlinux_pacman_install  "xsel"                #

    # Network data transfer
    is_cli_priority "critical" && homebrew_brew_install                  "wget"
    is_cli_priority "critical" && homebrew_brew_install                  "curl"
    is_cli_priority "optional" && homebrew_brew_install                  "httpie"              # Curl simplified
    is_cli_priority "optional" && homebrew_brew_install                  "tcpdump"             # TCP traffic sniffing

    # Network topology discovery
    is_cli_priority "optional" && homebrew_brew_install                  "nmap"                # Network Mapper
    is_cli_priority "optional" && homebrew_brew_install                  "fping"               # Parralel ping

    # Network performance
    is_cli_priority "optional" && homebrew_brew_install                  "iperf3"              # Network performance measurement

    # Network monitoring
    is_cli_priority "optional" && homebrew_brew_install                  "bandwhich"

    # Database/cache engines
    # - Redis
    is_cli_priority "optional" && homebrew_brew_install                  "redis"               # Redis Key-Value Storage
    # - Postgres
    is_cli_priority "optional" && homebrew_brew_install                  "pspg"                # Pager for psql official client

    # Multimedia tools
    is_cli_priority "optional" && homebrew_brew_install                  "fdk-aac"             # Fraunhofer FDK AAC library
    is_cli_priority "optional" && homebrew_brew_install                  "openssl"             # Openssl library
    is_cli_priority "optional" && homebrew_brew_install                  "libvmaf"             # VMAF brary
    is_cli_priority "optional" && homebrew_brew_install                  "jpeg-xl"             # JPEG-XL codec library
    is_cli_priority "optional" && homebrew_brew_install                  "zimg"                # Scaling, colorspace conversion, and dithering library

    #is_cli_priority "critical" && homebrew_brew_install                  "homebrew-ffmpeg/ffmpeg/ffmpeg \
    #                                        --with-fdk-aac \
    #                                        --with-openssl \
    #                                        --with-libvmaf \
    #                                        --with-jpeg-xl \
    #                                        --with-zimg"         # FFMPEG (using https://github.com/homebrew-ffmpeg/homebrew-ffmpeg's tap + dependencies above this line)

    # Multimedia players
    is_cli_priority "optional" && homebrew_brew_install                  "mpc"                 # Music player (CLI) client
    is_cli_priority "optional" && homebrew_brew_install                  "ncmpc"               # Music player (TUI) client

    # Multimedia servers
    is_cli_priority "optional" && homebrew_brew_install                  "mpd"                 # Music player daemon
    # - not using mopidy - prefer mpd
    if is_macos || is_fedora || is_archl; then
        # Wait for PR fix: https://github.com/mopidy/homebrew-mopidy/issues/44
        :
    else
        :
        #is_cli_priority "optional" && homebrew_brew_install                  "mopidy"              # Music server with cloud music support plugins
        #is_cli_priority "optional" && homebrew_brew_install                  "mopidy-mpd"          # Mopidi plugin to mpd clients
        #is_cli_priority "optional" && homebrew_brew_install                  "mopidy-local"        # Mopidi plugin to play local music
        #is_cli_priority "optional" && homebrew_brew_install                  "mopidy-somafm"       # Mopidi plugin to play somafm music
        #is_cli_priority "optional" && homebrew_brew_install                  "mopidy-soundcloud"   # Mopidi plugin to play soundcloud music
        #is_cli_priority "optional" && homebrew_brew_install                  "mopidy-spotify"      # Mopidi plugin to play spotify music
        #is_cli_priority "optional" && homebrew_brew_install                  "mopidy-tunein"       # Mopidi plugin to play tune-in music
    fi

    # Music download
    is_cli_priority "optional" && pipx_pipx_install                      "ytmdl"               # Youtube music downloader

    # Archive decompression
    is_cli_priority "optional" && homebrew_brew_install                  "unp"                 # Decompress anything
    is_cli_priority "optional" && homebrew_brew_install                  "ouch"                # Compress/decompress anything

    # Personal dashboard
    is_cli_priority "optional" && homebrew_brew_install                  "wtfutil"

    # Finding data
    is_cli_priority "critical" && homebrew_brew_install                  "fzf"                 # Ctrl+R replacement for searching the history / files
    is_cli_priority "critical" && homebrew_brew_install                  "fd"                  # A simpler find

    # CLI cheatsheet
    is_cli_priority "critical" && homebrew_brew_install                  "tlrc"                # Short manpage version, with example for most comman use cases
                                                                 # tldr: python client
                                                                 # tlrc: rust client
    is_cli_priority "critical" && homebrew_brew_install                  "cheat"               # Alternative short manpage version, with example for most comman use cases
    is_cli_priority "critical" && homebrew_brew_install                  "navi"                # Execute one liner from cheatsheet

    # Local system monitoring
    is_cli_priority "optional" && homebrew_brew_install                  "htop"                #
    is_cli_priority "optional" && homebrew_brew_install                  "glances"             # Extensive system monitoring

    # OpenSSH client / server
    is_cli_priority "critical" && is_macos  &&  homebrew_brew_install    "openssh"             # OpenSSH client and server
    is_cli_priority "optional" && is_fedora &&  fedora_dnf_install       "openssh-server"  \
              &&  fedora_dnf_install "__commit_aggregated__" \
              &&  systemd_systemctl_enable sshd \
              &&  systemd_systemctl_start  sshd
    is_cli_priority "critical" && is_archl  &&  archlinux_pacman_install "openssh" \
              &&  archlinux_pacman_install "__commit_aggregated__" \
              &&  systemd_systemctl_enable sshd \
              &&  systemd_systemctl_start  sshd

    # Firewall port knocking
    #is_cli_priority "optional" && is_macos  &&  homebrew_brew_install    "fwknop"             # Disabled by brew upstream
    #is_cli_priority "optional" && is_fedora &&  fedora_dnf_install       "fwknop"

    # De/Encryption
    is_cli_priority "critical" && homebrew_brew_install                  "gnupg"               # GNU implementation of PGP
    is_cli_priority "critical" && homebrew_brew_install                  "hopenpgp-tools"      # Verify PGP key setup best practice
    is_cli_priority "critical" && is_macos && homebrew_brew_install      "pinentry-mac"        # Connect gpg-agent to OSX keychain
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "pinentry"            #
    is_cli_priority "critical" && is_archl && archlinux_pacman_install   "pinentry"            #
    is_cli_priority "critical" && homebrew_brew_install                  "pgpdump"             # PGP packet/key analyser
    is_cli_priority "optional" && homebrew_brew_install                  "age"                 # File encryption for the masses

	# Secret sharing
    is_cli_priority "optional" && homebrew_brew_install                  "ots"                 # Time bound secret sharing

    # Container setup: docker
    is_cli_priority "optional" && homebrew_brew_install                  "docker"                                 # Container runtime engine. No need for macOS's Docker Desktop
    is_cli_priority "optional" && homebrew_brew_install                  "docker-buildx"                          # BuildKit extension
    is_cli_priority "optional" && homebrew_brew_install                  "docker-credential-helper"               # docker login support
    is_cli_priority "optional" && homebrew_brew_install                  "lazydocker"                             # TUI docker

    # Container setup: colima
    is_cli_priority "optional" && homebrew_brew_install                  "colima"              # Container runtime engine

    # Container: any
    is_cli_priority "optional" && homebrew_brew_install                  "dive"                # Inspect docker layers

    # Kubernetes
    is_cli_priority "optional" && homebrew_brew_install                  "boz/repo/kail"       # kubernetes pods console viewer
    is_cli_priority "optional" && homebrew_brew_install                  "k9s"                 # kubernetes cluster manager TUI

	# Text characters
    is_cli_priority "optional" && homebrew_brew_install                  "chars"               # Display name/code for ASCII/Unicode characters/code points

    # Text manipulation
    is_cli_priority "critical" && homebrew_brew_install                  "gawk"                # Required by: tmux-fingers plugin

    # XML Manipulation/query
    is_cli_priority "critical" && homebrew_brew_install                  "xml-coreutils"       # Command XML utilities (eg: xml-grep)
    is_cli_priority "optional" && homebrew_brew_install                  "xmlstarlet"          # Command XML utilities (eg: xmlstarlet)

    # CSV Manipulation/query
    is_cli_priority "optional" && homebrew_brew_install                  "csvkit"              # Swiss army knife for csv files

    # JSON Manipulation/query
    is_cli_priority "critical" && homebrew_brew_install                  "jq"                  # JSON manipulator

    # YAML Manipulation/query
    is_cli_priority "critical" && homebrew_brew_install                  "python-yq"           # YAML manipulator. Requires: jq

    # Terminal browser
    is_cli_priority "optional" && homebrew_brew_install                  "lynx"                # Terminal browser

    # File sharing
    is_cli_priority "optional" && homebrew_brew_install                  "ffsend"              # Firefox Send client. Required by 1 oh-my-shell plugin

    # i18n
    is_cli_priority "optional" && homebrew_brew_install                  "translate-shell"     # Translate any languages

    # Calculator
    is_cli_priority "critical" && homebrew_brew_install                  "libqalculate"        # qalc: General pupose calculator, to convert unit / dimension analysis
    is_cli_priority "critical" && homebrew_brew_install                  "pcalc"               # palc: hex/binary/decimal calculator

    # QR code
    is_cli_priority "optional" && homebrew_brew_install                  "qrencode"            # Generae QR code

    # Linter
    is_cli_priority "critical" && homebrew_brew_install                  "shellcheck"          # Lint bash/zsh/sh scripts
    is_cli_priority "critical" && homebrew_brew_install                  "shfmt"               # Format bash/posix scripts

    # Wireguard
    is_cli_priority "optional" && homebrew_brew_install                  "wireguard-tools"     # Wireguard tooling. Eg: wg

    # bmaptool
    is_cli_priority "optional" && pipx_pipx_install                      "https://github.com/yoctoproject/bmaptool/archive/refs/tags/v3.9.0.zip"               # Create file block map to speed up copying large image file

    # Virtualization
    is_cli_priority "optional" && is_macos  && homebrew_brew_install     "libvirt"             # KVM/Qemu machine definition / hypervision abstraction
    is_cli_priority "optional" && is_fedora && fedora_dnf_install        "libvirt"
    is_cli_priority "critical" && is_macos  && homebrew_brew_install     "qemu"
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "qemu"
    is_cli_priority "optional" && is_macos  && homebrew_brew_install     "virt-manager"        # QEMU Manager
    is_cli_priority "optional" && is_fedora && fedora_dnf_install        "virt-manager"
    is_cli_priority "optional" && is_archl  && archlinux_pacman_install  "virt-manager"
    if ! test "$BOOTSTRAP_SKIP_UNSUPPORTED_CPU_SETUP" = "0"
    then
        is_cli_priority "optional" && is_macos  && homebrew_brew_install     "multipass"       # Ubuntu's multipass
        is_cli_priority "optional" && is_macos  && homebrew_brew_install     "quickemu"
    fi

    # ISO
    is_cli_priority "optional" && homebrew_brew_install                  "xorriso"             # ISO9660+RR manipulation tool to kickstart a fedora vm with virt-install

    # Software defined radio
    #is_cli_priority "optional" && homebrew_brew_install                  "tdsmith/ham/xastir"  # HAM Station Tracking / Info reporting
    #is_cli_priority "optional" && homebrew_brew_install                  "tdsmith/ham/chirp"   # CHIRP software to configure HAM radios

    # Scrum
    # Daily standup manager
    # Task manager
    is_cli_priority "critical" && pipx_pipx_install                      "tasklog"             # Install tasklog cli
    is_cli_priority "optional" && homebrew_brew_install                  "task"                # Taskwarrior

    # AWS SDK
    if ci_is_ci; then
        # awscli dependes on python3.11 which
        # cannot be symlink to /usr/bin/2to3 witouth
        # error. Skipping dependencies for now
        awscli_args="--ignore-dependencies --overwrite"
    fi

    is_cli_priority "optional" && homebrew_brew_install   $awscli_args   "awscli"              # AWS CLI

    # Digital Ocean
    is_cli_priority "optional" && homebrew_brew_install                  "doctl"               # Digital Ocean CLI

    # Oracle Cloud SDK
    is_cli_priority "optional" && is_macos && homebrew_brew_install      "oci-cli"             # Oracle Cloud CLI

    # Timezone
    is_cli_priority "critical" && homebrew_brew_install                  "tz"                  # Timezone helper

    # Mastodon
    is_cli_priority "optional" && homebrew_brew_install                  "tut"                 # TUI mastodon client

    # Run command on event
    is_cli_priority "optional" && homebrew_brew_install                  "watch"               # Run a command at regular interval
    is_cli_priority "optional" && homebrew_brew_install                  "entr"                # Run command on files that have changed

    # Benchmarking
    is_cli_priority "optional" && homebrew_brew_install                  "hyperfine"           # benchmarking tool for CLI programs mostly

    # Image processing
    is_cli_priority "optional" && homebrew_brew_install                  "imagemagick"         # Required by spaceman-diff

    # Line oriented search tool
    is_cli_priority "critical" && homebrew_brew_install                  "ripgrep"             # faster grep "rigrep" binary compiled, as nightly build, and including SIMD and all optimizations enabled.
    is_cli_priority "critical" && homebrew_brew_install                  "ripgrep-all"         # "rigrep" binary for additional file types

    # AST oriented search tool
    is_cli_priority "critical" && homebrew_brew_install                  "ast-grep"            # AST based code structural search
                                                                 # Required by VIM's fzf.vim plugin
    # Terminal Image protocol
    is_cli_priority "critical" && homebrew_brew_install                  "libsixel"            #

    # Search any kind of doc
    is_cli_priority "critical" && homebrew_brew_install                  "rga"                 # "rigrep" extended to most file formats: PDF, ebooks, office documents, zip, tar.gz, etc
    is_cli_priority "critical" && homebrew_brew_install                  "pandoc"              # required by 'rga'
    is_cli_priority "critical" && homebrew_brew_install                  "poppler"             # required by 'rga'

    # Source code search tool
    is_cli_priority "critical" && homebrew_brew_install                  "the_silver_searcher" # Faster than 'ack' file content search too

    # Keychain
    is_cli_priority "critical" && homebrew_brew_install                  "pass" 		         # Password storage

    # Shell prompt
    is_cli_priority "critical" && homebrew_brew_install                  "starship" 		     # Cross platfrom shell prompt

    # terminfo database
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "ncurses-term"        # ncurses v6.2+'s terminfo database with kitty/alacritty/ghostty terminal support
    is_cli_priority "critical" && is_macos  && homebrew_brew_install     "ncurses" 		     # Starting with macOS Sonoma's built-in ncurses, kitty/alacritty terminal is supported
    is_cli_priority "critical" && is_archl  && archlinux_pacman_install  "ncurses"             # ncurses v6.2+'s terminfo database with kitty/alacritty terminal support

    is_cli_priority "optional" && is_macos  && homebrew_brew_install     "pcsc-lite"           # Smart card access middleware for SCard API (PC/SC)
    is_cli_priority "optional" && is_fedora && fedora_dnf_install        "pcsc-lite"
    is_cli_priority "optional" && is_archl  && archlinux_pacman_install  "pcsclite"
    #is_cli_priority "optional" && is_macos  && homebrew_brew_install     "pcsc-lite-ccid"      # Generic USB CCCID (Chip/Smart Card Interface Driver) and ICC (Integrated Circuit Interface driver)
    is_cli_priority "optional" && is_fedora && fedora_dnf_install        "pcsc-lite-ccid"
    is_cli_priority "optional" && is_archl  && archlinux_pacman_install  "ccid"
    #is_cli_priority "optional" && is_macos  && homebrew_brew_install     "pcsc-tools"          # Scan smart cards
    is_cli_priority "optional" && is_fedora && fedora_dnf_install        "pcsc-tools"

    is_cli_priority "optional" && is_fedora && systemd_systemctl_enable  "pcscd" \
              && systemd_systemctl_start   "pcscd"
    is_cli_priority "optional" && is_archl  && systemd_systemctl_enable  "pcsclite" \
              && systemd_systemctl_start   "pcsclite"

    # Tabular data
    is_cli_priority "optional" && is_macos  && homebrew_brew_install      "visidata"           # Visualize tabular data in the terminal
    is_cli_priority "optional" && is_fedora && fedora_dnf_install         "visidata"
    is_cli_priority "optional" && is_archl  && archlinux_pacman_install   "visidata"

    # Typing
    is_cli_priority "optional" && cargo_install                           "thokr"               # Typing tester

    # LLM client
    #                                                            # Lx: https://prompt.16x.engineer/blog/ai-coding-l1-l5
    is_cli_priority "optional" && homebrew_brew_install                  "aichat"              # L1: Code completion / question
    is_cli_priority "optional" && homebrew_brew_install                  "aider"               # L2: Task level completion / Ticket to code

    # Misc
    is_cli_priority "optional" && homebrew_brew_install                  "fortune"             # Fortune cookie
    is_cli_priority "optional" && homebrew_brew_install                  "jp2a"                # Convert images to ASCII. Required by spaceman-diff
    is_cli_priority "critical" && homebrew_brew_install                  "pv"                  # pipe data flow speed progress indicator
    is_cli_priority "optional" && homebrew_brew_install                  "pstree"              # Show ps output as a tree
    is_cli_priority "optional" && homebrew_brew_install                  "libfaketime"         # Freeze system clock for a given application (eg: shell script)
    is_cli_priority "critical" && homebrew_brew_install                  "expect"              # Automate interactive program interactions
    is_cli_priority "critical" && homebrew_brew_install                  "xdg-ninja"           # Recommands where to move files per program when programs support XDG directories structures
    is_cli_priority "critical" && homebrew_brew_install                  "tree"                # Print directory content as tree structure
    is_cli_priority "critical" && homebrew_brew_install                  "rlwrap"              # Needed to execute PlistBuddy in command mode
    is_cli_priority "critical" && homebrew_brew_install                  "ngrep"               # grep for network resource
    is_cli_priority "critical" && is_macos && homebrew_brew_install      "trash"               # Move files into macOS user's trash bin (as if done from the Finder)
    is_cli_priority "critical" && homebrew_brew_install                  "so"                  # Query stackoverflow TUI
    is_cli_priority "critical" && homebrew_brew_install                  "universal-ctags"     # catgs for vim's TagBar

    # Shell formatter
    is_cli_priority "critical" && homebrew_brew_install                  "shfmt"               # Shell script formatter

    # Language syntax parser
    is_cli_priority "critical" && homebrew_brew_install                  "tree-sitter-cli"     # Parser generator for neovim's treesiter plugin

    # Matrix
    is_cli_priority "optional" && homebrew_brew_install                  "iamb"                # Matrix client CLI with vim bindings

    # UART/Serial terminal
    is_cli_priority "optional" && homebrew_brew_install                  "tio"                 # Simple UART terminal

    # Cloud Proxy
    is_cli_priority "optional" && homebrew_brew_install                  "grok"                # Grok for HTTP(s)/TCP - no UDP!
    is_cli_priority "optional" && homebrew_brew_install                  "zrok"                # Grok like for HTTP(s)/TCP/UDP

    # MQTT client
    is_cli_priority "optional" && homebrew_brew_install                  "emqx/mqttx/mqttx-cli" # mqtt cli client
    is_cli_priority "optional" && homebrew_brew_install                  "mqttui"               # mqtt tui client

    # File system file content hashing
    is_cli_priority "optional" && homebrew_brew_install                  "md5deep"             # Hashdeep for to check against  whole file system corruption

    # Grammer checker
    is_cli_priority "optional" && homebrew_brew_install                  "harper"              # Fast grammar checker

    # K8s
    is_cli_priority "optional" && is_fedora &&  homebrew_brew_install    "kubectl"             # K8s client only
    is_cli_priority "optional" && is_archl  &&  homebrew_brew_install    "kubectl"

    is_cli_priority "optional" && is_fedora && fedora_dnf_install        "fuse3"               # Hardware smartcard requirements
    is_cli_priority "optional" && is_archl  && archlinux_pacman_install  "fuse3"
    is_cli_priority "optional" && is_fedora && fedora_dnf_install        "fuse3-devel"

    is_cli_priority "critical" && homebrew_brew_install                  "__commit_aggregated__"
    is_cli_priority "critical" && is_fedora && fedora_dnf_install        "__commit_aggregated__"
    is_cli_priority "critical" && is_archl  && archlinux_pacman_install  "__commit_aggregated__"
fi

if is_profile_admin; then
    is_cli_priority "critical" && is_macos && homebrew_brew_tap_install "homebrew/autoupdate"  # Auto update homebrew packages every 31d
    is_cli_priority "critical" && is_macos && brew autoupdate start "2678400" --upgrade --cleanup
fi

# Install (bash/zsh)-completions
if is_profile_admin_or_similar; then
    is_cli_priority "critical" && homebrew_brew_install                  "zsh-autosuggestions"
    is_cli_priority "critical" && homebrew_brew_install                  "zsh-autocomplete"

    is_cli_priority "critical" && homebrew_brew_install                  "zsh-completions"
    is_cli_priority "critical" && homebrew_brew_install                  "bash-completion@2"    # bash-completion support pre bash v4. bash-completion@2 support bash v4+

    is_cli_priority "critical" && homebrew_brew_install "__commit_aggregated__"
fi

if is_profile_admin || is_profile_dev_single || is_profile_dev_multi; then
    tmux_install_tpm
fi
