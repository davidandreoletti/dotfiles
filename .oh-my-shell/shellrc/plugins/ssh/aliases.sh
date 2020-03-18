# Generate RSA 4k key pair
# Usage: ssh_key_generate_rsa_4096 <no-args>
alias ssh_key_generate_rsa_4096='ssh-keygen -t rsa -b 4096'

# Fix SSH key pair. Typically you want: 
# - .ssh directory permissions to be 700 (drwx------) 
# - public key (.pub file) to be 644 (-rw-r--r--). 
# - private key (id_rsa) should be 600 (-rw-------).
# Usage: ssh_key_protect /path/to/key.rsa
alias ssh_key_protect='chmod 700'

# Indicate if passphrase is correct for this private key
# Usage: ssh_is_private_key_password_correct /path/to/private/key
alias ssh_is_private_key_password_correct='f_ssh_is_private_key_password_correct '

# Show public key hashes (MD5, SHA, etc)
# Usage: ssh_show_key_hashes "absolute path to ssh key private or public, but generally public"
alias ssh_show_key_hashes='f_ssh_show_key_hashes '

# Read Public key from PEM file (for example to output the public key into an ~/.ssh/authorized_keys file)
# Usage: ssh_extract_from_pem_public_key_only_as_rsa_format "/path/to/some/file.pem"
alias ssh_extract_from_pem_public_key_only_as_rsa_format='ssh-keygen -y -f '

