if command_exists 'dua'; then
    # Disk usage analyzer
    # Usage: tdisk_usage_analyzer /path/fo/folder
    alias tdisk_usage_analyzer='dua i '
elif command_exists 'ncdu'; then
    alias tdisk_usage_analyzer='ncdu '
fi
