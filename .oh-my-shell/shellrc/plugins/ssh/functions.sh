f_ssh_is_private_key_password_correct() {
    local keyPath="$1"
    ssh-keygen -y -f "$keyPath" && echo "Password: OK" || echo "Password: INCORRECT"
}

f_ssh_show_key_hashes() {
    local keyPath="$1"
    ssh-keygen -E md5 -lf "$keyPath" 
    ssh-keygen -E sha256 -lf "$keyPath"
}

