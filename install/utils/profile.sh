###############################################################################
# Profile related functions
###############################################################################

is_profile_normal() {
    echo "$BOOTSTRAP_PROFILE" | grep -q "^normal";
    return $?
}

is_profile_admin() {
    echo "$BOOTSTRAP_PROFILE" | grep -q "^admin";
    return $?
}

is_profile_dev_single() {
    echo "$BOOTSTRAP_PROFILE" | grep -q "^dev_single";
    return $?
}

is_profile_dev_multi() {
    echo "$BOOTSTRAP_PROFILE" | grep -q "^dev_multi";
    return $?
}

is_profile_admin_or_similar() {
    is_profile_admin && return 0
    is_profile_dev_single && return 0
    return 1
}
