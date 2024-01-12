# Encrypt content with a one time generated passphrase
# usage: encrypt_message_armored_oneshot message.txt > message.txt.age
alias encrypt_message_armored_oneshot='command age --armor --passphrase '

# Decrypt content with passphrase
# usage: decrypt_message_armored_oneshot message.txt.age
alias decrypt_message_armored_oneshot='command age --decrypt '
