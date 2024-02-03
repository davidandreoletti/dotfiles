# % gnupg, key, perfect
# # Create master key with (C)ertify capability + one different sub key for (S)ign, (E)ncrypt, (A)uthenticate
# ; usage: gnupg_create_CSEA_perfect_key "John Doe" "john@doe.com" "1y" 
alias gnupg_create_CSEA_perfect_key='f_gnupg_create_CSEA_key '

# % gnupg, key, export, public, private
# # Export both public + private keys
# ; usage: gnupg_export_public_and_private_key "GPG keyfingerprint"
alias gnupg_export_public_and_private_key='f_gnupg_export_public_and_private_key '

# % gnupg, key, import, public, private
# # Import both public + private keys
# ; usage: gnupg_import_public_and_private_key "GPG keyfingerprint"
alias gnupg_import_public_and_private_key='f_gnupg_import_public_and_private_key'
