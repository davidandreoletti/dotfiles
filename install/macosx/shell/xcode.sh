#! /bin/bash
###############################################################################
# Xcode related functions
###############################################################################

xcode_is_installed() {
    # Method 1
    if xcodebuild -version; then
        return 0
    else
        return 1
    fi
    
    # Method 2
    # which xcode-select && [ -d `xcode-select --print-path` ];
    # return $?;
}

xcode_cli_is_installed() {
    if test -e "/Library/Developer/CommandLineTools/usr/bin/git"; then
        return 0
    else
        return 1
    fi
}

xcode_show_not_installed_message() {
    message_info_show "Xcode is not installed. Xcode command line tools is not sufficient. "
    message_info_show "Please install Xcode and launch the script again."
}

xcode_show_command_line_tool_install_request() {
    # Homebrew requires it and will attempt to install it on >10.8
    sudo ${SUDO_OPTIONS} /usr/bin/xcode-select --install
} 

