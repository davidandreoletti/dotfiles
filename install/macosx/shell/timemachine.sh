DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE="/Library/Preferences/com.apple.TimeMachine.plist"

timemachine_has_entry_value() {
    local path="$1"
    local value="$2"
    local file="$3"

    sudo /usr/libexec/PlistBuddy -c "Print $path" "$file" | grep "$value"
}

timemachine_add_unique_exclusion_entry() {
    local path="$1"
    local value="$2"
    local file="$3"
    timemachine_has_entry_value "$path" "$value" "$file" || sudo /usr/libexec/PlistBuddy -c "Add :'$path':0 string '$value'" "$file"
}

timemachine_add_new_array_entry() {
    local path="$1"
    local file="$2"
    sudo /usr/libexec/PlistBuddy -c "Add '$path' array" "$file"
}

timemachine_defaults() {
    sudo tmutil disable
    # Excludes additional folders from Time Machine
    sudo plutil -convert xml1 "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    ## System wide excludes
    timemachine_has_entry_value "SkipPaths" "/Applications" "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE" || timemachine_add_new_array_entry "SkipPaths" "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    timemachine_add_unique_exclusion_entry "SkipPaths" "/Applications" "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    ## Per User home directory excludes
    timemachine_add_unique_exclusion_entry "SkipPaths" "$HOME/Downloads" "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    timemachine_add_unique_exclusion_entry "SkipPaths" "$HOME/Applications" "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    ### NOTE: add directory not in the output of this command:
    ###       sudo mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"
    timemachine_add_unique_exclusion_entry "SkipPaths" "$HOME/.cache" "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    timemachine_add_unique_exclusion_entry "SkipPaths" "$HOME/Library/Caches" "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    timemachine_add_unique_exclusion_entry "SkipPaths" "$HOME/.mail" "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    sudo cat "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    sudo plutil -convert binary1 "$DEFAULT_TIMEMACHINE_EXCLUSION_LIST_FILE"
    sudo tmutil enable
}

timemachine_start_backup() {
    sudo tmutil startbackup
}
