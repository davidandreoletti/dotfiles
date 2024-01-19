function f_shareFile() {
    local exiration="$1" # eg: 1d, 2w, 3y
    local filePath="$2"

    curl -F "file=@$filePath" https://file.io/?expires="$exiration"
}
