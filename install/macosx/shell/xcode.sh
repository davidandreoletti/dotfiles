#! /bin/bash
###############################################################################
# Xcode related functions
###############################################################################

xcode_is_installed() {
    # Method 1
    xcodebuild -version
    local isXcodeInstalled=`echo $?`
    [[ $? == 0 ]] || return 1 
    return 0
    
    # Method 2
    # which xcode-select && [ -d `xcode-select --print-path` ];
    # return $?;
}

xcode_show_not_installed_message() {
    message_info_show "Xcode is not installed. Xcode command line tools is not sufficient. "
    message_info_show "Please install Xcode and launch the script again."
}

xcode_show_command_line_tool_install_request() {
    # Homebrew requires it and will attempt to install it on >10.8
    sudo ${SUDO_OPTIONS} /usr/bin/xcode-select --install
} 

