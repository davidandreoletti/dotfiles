if is_macos; then
    FIND_BIN="/usr/bin/find"

    if /usr/libexec/java_home -F >/dev/null 2>&1; then
        DEFAULT_JAVA_HOME="$(/usr/libexec/java_home)"
    else
        # Since macOS 13+, java is not installed by default
        # Use homebrew's java as system java
        DEFAULT_JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
    fi

    ########################################################
    # IMPORTANT: jenv's initialization unsets JAVA_HOME.
    # User is expected to set it via jenv
    ########################################################
    #
    # 1. Export JAVA_HOME for GUI/shell applications
    # Java version used: most recent installed
    launchctl setenv JAVA_HOME "$DEFAULT_JAVA_HOME"

    # 2. Export "JAVA_HOME" for shell applications
    # Java version used for tooling like android/gradle
    export JAVA_HOME="$DEFAULT_JAVA_HOME"
fi
