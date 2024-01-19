f_ssh_is_private_key_password_correct() {
    local keyPath="$1"
    ssh-keygen -y -f "$keyPath" && echo "Password: OK" || echo "Password: INCORRECT"
}

f_ssh_show_key_hashes() {
    local keyPath="$1"
    ssh-keygen -E md5 -lf "$keyPath"
    ssh-keygen -E sha256 -lf "$keyPath"
}

f_ssh_home_fix_files_and_folders_permissions() {
    local sshDir="${1:-"$HOME/.ssh"}"
    chmod 700 "$sshDir"
    find -L "$sshDir" -type f -exec chmod -v 600 {} \;
    find -L "$sshDir" -type d -exec chmod -v 700 {} \;
}
