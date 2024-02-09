# dd a source to a destination with on the fly checksum for the source and post copy checksum for the destination
# Usage: dd_verify /dev/input-disk /dev/output-disk
# Usage: dd_verify /path/file.img /dev/output-disk
# Usage: dd_verify /dev/input-disk /path/file.img
# Usage: dd_verify /path/file.img.zst /dev/output-disk
# Usage: dd_verify /dev/input-disk /path/file.img.zst 'zstd'
alias dd_verify='f_dd_verify '
