# Disk storage usage analyzer
if command_exists 'dua'; then
    # Usage: tdisk_usage_analyzer /path/fo/folder
    alias tdisk_usage_analyzer='dua i '
elif command_exists 'ncdu'; then
    alias tdisk_usage_analyzer='ncdu '
fi

# Disk I/O usage
if is_linux; then
    alias tdisk_usage_io='iostat -x 1 10 '
elif is_macos; then
    alias tdisk_usage_io='iostat -c 10 -w 1'
fi
