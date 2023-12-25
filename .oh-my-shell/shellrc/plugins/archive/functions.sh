# Archive each root level folder in the specified path
# Usage: f_archiveEachFolderSeparatedely "/path/to/a/folder"
function f_archiveEachFolderSeparatedely() {
    local dirPath="$1"
    for i in $dirPath/*/; 
    do 
        zip -r "${i%/}.zip" "$i"; 
    done
}

# Send a directory to the network as compressed tar file
function f_archiveSendToNetwork() {
    local dirPath="$1"
    local host="$2"
    local port="$3"

    tar czf - "$dirPath" | zstd | pv | nc $host $port
}

# Receive a tar file from the network and extract it in the provided directory 
function f_archiveReceiveFromNetwork() {
    local dirPath="$1"
    local port="$3"

    nc -l -p $port | zstdcat | pv | tar -xz -C "$dirPath"
}
