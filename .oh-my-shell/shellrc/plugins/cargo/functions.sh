f_cargo_package_install() {
    local pkgname="$1"

    local package_tmp_dir="/tmp/$USER.cargo.$pkgname.build"
    mkdir -p "$package_tmp_dir"
    CARGO_BUILD_TARGET_DIR="$package_tmp_dir" cargo install "$pkgname"
}
