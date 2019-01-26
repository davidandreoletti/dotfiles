os_type_name=`get_os_type`
if [[ "$os_type_name" == "macosx" ]]; then
    # Initialize jenv files
    eval "$(jenv init -)" 
    # Register Java SDKs
    find "/Library/Java/JavaVirtualMachines" -mindepth 1 -maxdepth 1 -type d -name "*jdk*" -exec bash -c "yes | jenv add \"{}/Contents/Home\" > /dev/null 2>&1" \;
    #Export JAVA_HOME with jenv export command
    jenv enable-plugin export > /dev/null  2>&1; 
    # By default, jenv uses the most recent version
    mostRecentJavaVersion=`jenv versions | sort | head -n1 | cut -f1`; 
    mostRecentJavaVersion=`echo "$mostRecentJavaVersion" | sed 's/ //g'`;
    echo "$mostRecentJavaVersion" > $HOME/.java-version
fi
unset os_type_name
