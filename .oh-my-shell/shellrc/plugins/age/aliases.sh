# % age, encrypt, message
# # Encrypt content with a one time generated passphrase
# ; usage: encrypt_message_armored_oneshot <message_file> > <message_file>.age
alias encrypt_message_armored_oneshot='command age --armor --passphrase '

# % age, decrypt, message
# # Decrypt content with passphrase
# ; usage: decrypt_message_armored_oneshot <message_file>.age
alias decrypt_message_armored_oneshot='command age --decrypt '
