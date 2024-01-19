function f_search_code_fragment() {
    local pattern="$1"
    local dir="${2:-.}"

    # with ag - respects .agignore and .gitignore
    ag --nobreak --nonumbers --noheading "$pattern" $dir
}

function f_search_anything() {
    local pattern="$1"
    local dir="${2:-.}"

    # with ag - respects .agignore and .gitignore
    rga --rga-accurate "$pattern" $dir
}
