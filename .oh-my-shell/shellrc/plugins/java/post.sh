if [[ "$OS_NAME" == "macosx" ]]; then
	#
    # Initialize jenv
    # (easier JAVA_HOME switching)
    #
    #eval "$(jenv init - --no-rehash)"

    # Register JDK with jenv
    (
        # Register already installed JDKs
        find "/Library/Java/JavaVirtualMachines" -mindepth 1 -maxdepth 1 -type d -name "*jdk*" -exec bash -c "yes | jenv add \"{}/Contents/Home\" > /dev/null 2>&1" \;
        find "/Library/Java/JavaVirtualMachines" -mindepth 1 -maxdepth 1 -xtype d -name "*jdk*" -exec bash -c "yes | jenv add \"{}/Contents/Home\" > /dev/null 2>&1" \;
        # Register perhaps not already registered JDKs
        find $HOMEBREW_CELLAR -type d -regex ".*openjdk.jdk$"  -exec bash -c "yes | jenv add {}/Contents/Home" \;
        # Notify jenv to reload shims
        jenv rehash
    ) > /dev/null 2>&1

    ########################################################
    # IMPORTANT: jenv's initialization unsets JAVA_HOME.
    # User is expected to set it via jenv
    ########################################################
    #
	# 1. Export JAVA_HOME for GUI/shell applications
	# Java version used: most recent installed
    launchctl setenv JAVA_HOME `/usr/libexec/java_home`

    # 2. Export "JAVA_HOME" for shell applications
    # Java version used for tooling like android/gradle
    export JAVA_HOME="$(/usr/libexec/java_home)"
fi
