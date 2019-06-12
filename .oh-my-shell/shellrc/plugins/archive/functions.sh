# Archive each root level folder in the specified path
# Usage: f_archiveEachFolderSeparatedely "/path/to/a/folder"
function f_archiveEachFolderSeparatedely() {
    local dirPath="$1"
    for i in $dirPath/*/; 
    do 
        zip -r "${i%/}.zip" "$i"; 
    done
}
