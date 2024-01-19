# Backup file/dir with simple "-xxx" suffix
f_backup_duplicate_with_simple_numbering() {
    local relsrcfile=$(echo "$1" | sed -e 's#/$##')
    local abssrcfile=$(pwd)"/$relsrcfile"
    local suffixdelimiter="-"

    # Find next free number
    local number=0
    local suffix
    until [ ! -e "$relsrcfile$suffix" ]; do
        numberformat=$(printf "%03i" $number)
        suffix="$suffixdelimiter$numberformat"
        number=$((number + 1))
    done

    echo "$relsrcfile -> $relsrcfile$suffix"
    cp -rfp $relsrcfile{,$suffix}
}
