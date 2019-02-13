if [[ "$OS_NAME" == "macosx" ]]; then
	#Export JAVA_HOME for GUI/shell applications
    launchctl setenv JAVA_HOME `/usr/libexec/java_home`

    # Export "JAVA_HOME" for shell application only
    # via jenv. Useful for custom development
    # Initialize jenv files
    eval "$(jenv init -)" 
    # Register Java SDKs
    find "/Library/Java/JavaVirtualMachines" -mindepth 1 -maxdepth 1 -type d -name "*jdk*" -exec bash -c "yes | jenv add \"{}/Contents/Home\" > /dev/null 2>&1" \;
    #jenv used to select a specific java version
    jenv enable-plugin export > /dev/null  2>&1; 
    # By default, jenv uses the most recent version
    mostRecentJavaVersion=`jenv versions | sort | head -n1 | cut -f1`; 
    mostRecentJavaVersion=`echo "$mostRecentJavaVersion" | sed 's/ //g'`;
    echo "$mostRecentJavaVersion" > $HOME/.java-version
fi
