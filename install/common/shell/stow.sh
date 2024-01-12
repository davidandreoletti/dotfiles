function stow_files() {
    local user="$1"
    local sourceDir="$2"
    local destDir="$3"

    if ! command -v stow > /dev/null 2>&1
    then
        echo "Error: missing GNU stow"
        exit 1
    fi

    local package="$(basename $sourceDir)"
    #stow_options="--simulate"
    command stow ${stow_options} --verbose=1 --restow --dir="$(realpath $sourceDir/..)" --target="$(realpath $destDir)" $package
}
