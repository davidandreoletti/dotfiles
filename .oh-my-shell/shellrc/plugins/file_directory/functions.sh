#
# Exiting file & directory manipulation
#

# Swap two files/directory together
# Usage: f_swap_files file1 file2
function f_file_directory_swap() {
    local TMPFILE=tmp.$$
    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1
    command mv -v "$1" $TMPFILE && command mv -v "$2" "$1" && command mv -v $TMPFILE "$2"
}

function f_file_directory_create_missing_dirs_file() {
    local mode=$1
    local missing_path="$2"

    mkdir -p "$(dirname $missing_path)" \
        && command touch "$missing_path"

    if test $1 -eq 0; then
        $EDITOR "$missing_path"
    fi
}
