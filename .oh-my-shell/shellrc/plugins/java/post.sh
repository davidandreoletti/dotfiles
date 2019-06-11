if [[ "$OS_NAME" == "macosx" ]]; then
	#
    # Initialize jenv
    # (easier JAVA_HOME switching)
    #
    #eval "$(jenv init - --no-rehash)"
    (
        # Register Installed Java SDKs with jenv
        find "/Library/Java/JavaVirtualMachines" -mindepth 1 -maxdepth 1 -type d -name "*jdk*" -exec bash -c "yes | jenv add \"{}/Contents/Home\" > /dev/null 2>&1" \; &
        jenv rehash &
    ) 2> /dev/null

    # jenv used to select a specific java version
    #jenv enable-plugin export > /dev/null  2>&1; 
    # By default, setup jenv to use the most recent version
    #mostRecentJavaVersion=`jenv versions | sort | head -n1 | cut -f1`; 
    #mostRecentJavaVersion=`echo "$mostRecentJavaVersion" | sed 's/ //g'`;
    #echo "$mostRecentJavaVersion" > $HOME/.java-version


    #
    # IMPORTANT: jenv's initialization unsets JAVA_HOME.
    # User is expected to set it via jenv
    #

	# Export JAVA_HOME for GUI/shell applications
	#

	# Java version used: most recent installed
    launchctl setenv JAVA_HOME `/usr/libexec/java_home`

    #
    # Export "JAVA_HOME" for shell applications
    #

    # Javaversion used: 1.8.x) for tooling like android/gradle
    export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
fi
