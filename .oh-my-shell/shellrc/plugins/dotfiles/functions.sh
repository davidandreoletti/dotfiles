function f_dotfiles_get_host_ip() {
    if is_macos; then
        echo "$(command ipconfig getiflist | xargs -n 1 command ipconfig getifaddr | command head -1)"
    elif is_linux; then
        echo "$(command hostname -I | command awk '{print $1}')"
    else
        echo "127.0.0.1"
    fi
}


function f_dotfiles_transfer_clean () {
    local dotfiles_dir="$1"
    local dotfiles_private_dir="$2"

    local host_ip="$(f_dotfiles_get_host_ip)"
    local port="1234"

    for repository_dir in "$dotfiles_dir" "$dotfiles_private_dir";
    do

        echo "Sender computer: Waiting to send $repository_dir as git bundle over port $port"
        echo "Receiver computer: nc $host_ip $port > /tmp/$RANDOM.bundle"
        if pushd "$repository_dir" > /dev/null; then
            command git bundle create --progress - --all | command nc -l -p $port
            popd > /dev/null
        else
            echo "ERROR: $repository_dir is missing"
            return 1
        fi
    done
}

function f_dotfiles_transfer_dirty () {
    local dotfiles_dir="$1"
    local dotfiles_private_dir="$2"

    local host_ip="$(f_dotfiles_get_host_ip)"
    local port="1234"

    for repository_dir in "$dotfiles_dir" "$dotfiles_private_dir";
    do
        echo "Sender computer: Waiting to send $repository_dir as tar over port $port"
        echo "Receiver computer: nc $host_ip $port | tar --cd /path/to/existing/dir/to/extract/into/ --extract -keep-old-files --verbose"
        if pushd "$repository_dir" > /dev/null; then
            command tar --create --gzip --file - . | command nc -l -p $port
            popd > /dev/null
        else
            echo "ERROR: $repository_dir is missing"
            return 1
        fi
    done
}
