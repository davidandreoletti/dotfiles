f_termbin_copy_from() {
    local name="$1"

    curl "termbin.com/$name"| tee /dev/tty | ~/.bin/clipboard --to-system
}
