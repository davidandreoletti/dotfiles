is_cli_priority() {
    local priority="$1" # valid values: critical, optional
    
    if test "$BOOTSTRAP_SKIP_APP_CLI_NON_CRITICAL" = "0"; then
        if test "$priority" = "critical"; then
            return 0
        fi
        return 1
    fi
    return 0
}
