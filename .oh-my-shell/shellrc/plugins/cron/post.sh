USER_CRONTAB_FILE="$HOME/.crontab"
if is_macos; then
    # macOs:
    #  - crontab will copy ~/.crontab into the default user crontab at /usr/lib/cron/tabs/some-username
    #    This operation requires permission to access system directories.
    #    Therefore not running crontab
    :
elif is_linux; then
    if ! crontab -T "$USER_CRONTAB_FILE" >/dev/null 2>&1; then
        echo "$USER_CRONTAB_FILE is not a valid crontab file."
    else
        crontab "$USER_CRONTAB_FILE" >/dev/null 2>&1
    fi
fi
