ci_is_ci() {
    if test -n "$CI"; then
        return 0
    else
        return 1
    fi
}
