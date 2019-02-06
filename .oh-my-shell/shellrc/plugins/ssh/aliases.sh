alias ssh_key_generate_rsa_4096='ssh-keygen -t rsa -b 4096'

alias ssh_key_protect='chmod 700'

#Typically you want the .ssh directory permissions to be 700 (drwx------) and the public key (.pub file) to be 644 (-rw-r--r--). Your private key (id_rsa) should be 600 (-rw-------).
# usage: ssh_is_private_key_password_correct and let yourself be guided by the command execution
alias ssh_is_private_key_password_correct='echo "Type ssh key full path" && read path && ssh-keygen -y -f "$path" && echo "Passowrd is correct for $path" || echo "Password incorrect for $path"'

# Usage: ssh_show_key_hashes "absolute path to ssh key private or public, but generally public"
alias ssh_show_key_hashes='echo "Type ssh key full path" && read path && ssh-keygen -E md5 -lf "$path" && ssh-keygen -E sha256 -lf "$path"'

# Read Public key from PEM file (for example to output the public key into an ~/.ssh/authorized_keys file)
# Usage: ssh_extract_from_pem_public_key_only_as_rsa_format "/path/to/some/file.pem"
alias ssh_extract_from_pem_public_key_only_as_rsa_format='ssh-keygen -y -f '

