if command_exists 'bmaptool'; then
    # dd like a source to a destination with checksum and sparse zone efficiently processed for the source
    # Usage: dd_verify /dev/input-disk /path/file.img
    alias dd_verify='f_dd_create_then_copy_file '
else
    # dd a source to a destination with on the fly checksum for the source and post copy checksum for the destination
    # Usage: dd_verify2 /dev/input-disk /dev/output-disk
    # Usage: dd_verify2 /path/file.img /dev/output-disk
    # Usage: dd_verify2 /dev/input-disk /path/file.img
    # Usage: dd_verify2 /path/file.img.zst /dev/output-disk
    # Usage: dd_verify2 /dev/input-disk /path/file.img.zst 'zstd'
    alias dd_verify2='f_dd_verify '
fi
