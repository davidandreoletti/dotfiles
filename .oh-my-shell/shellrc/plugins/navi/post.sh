# Add cheatsheets
# FIXME: auto install once non interactive support is supported: https://github.com/denisidoro/navi/issues/863

f_navi_install_repo() {
    local url="$1"
    local name="$2"

    local cheatpath="$(navi info cheats-path)"
    local dir="$cheatpath/$name"

    git -C "$dir" pull || git clone "$url" "$dir"

}

#navi repo add denisidoro/navi-tldr-pages
f_navi_install_repo "https://github.com/denisidoro/navi-tldr-pages" "denisidoro__navi-tldr-pages"