if is_macos; then
    FIND_BIN="/usr/bin/find"

    #
    # Initialize jenv
    # (easier JAVA_HOME switching)
    #
    eval "$(jenv init - --no-rehash)"

    # Register JDK with jenv
    (
        # Register already installed JDKs
        $FIND_BIN "/Library/Java/JavaVirtualMachines" -mindepth 1 -maxdepth 1 -type d -name "*jdk*" -exec bash -c "yes | jenv add \"{}/Contents/Home\"" \;
        $FIND_BIN "/Library/Java/JavaVirtualMachines" -mindepth 1 -maxdepth 1 -xtype d -name "*jdk*" -exec bash -c "yes | jenv add \"{}/Contents/Home\"" \;
        # Register perhaps not already registered JDKs
        for directory in $HOMEBREW_CELLAR/openjdk*; do
            $FIND_BIN $directory -depth -maxdepth 4 -type d -regex ".*openjdk.jdk$" -exec bash -c "yes | jenv add {}/Contents/Home" \;
        done
        # Notify jenv to reload shims
        jenv rehash
    ) >/dev/null 2>&1
fi
