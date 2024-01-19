f_navi_generate_user_cheatsheet_from_aliases() {
    # Generate cheat file using aliases documentation from ~/.oh-my-shell/shellrc/plugins/*/aliases.sh
    # Until there is native support for it htts://github.com/denisidoro/navi/blob/master/docs/cheatsheet_syntax.md#syntax-overview"

    PERSO_CHEAT_FILE="$(navi info cheats-path)/${USER}_local/aliases.cheat"
    mkdir -p "$(dirname $PERSO_CHEAT_FILE)"

    #command cat ~/.oh-my-shell/shellrc/plugins/age/aliases.sh | \
    #    awk '/% / {p=1; next};
    #     /alias / {p=0};
    #     {if (p==1) print $0}'

    # INPUT FILE
    # % age, encrypt, message
    # # Encrypt content with a one time generated passphrase
    # ; usage: encrypt_message_armored_oneshot <message_file> > <message_file>.age
    #alias encrypt_message_armored_oneshot='command age --armor --passphrase '
    # % age, decrypt, message
    # # Decrypt content with passphrase
    # ; usage: decrypt_message_armored_oneshot message.txt.age
    #alias decrypt_message_armored_oneshot='command age --armor --passphrase '

    # OUTPUT FILE
    # % age, encrypt, message
    # # Encrypt content with a one time generated passphrase
    # encrypt_message_armored_oneshot <message_file> > <message_file>.age
    #alias encrypt_message_armored_oneshot='command age --armor --passphrase '

    #command cat $SHELLRC_PLUGINS_DIR_LOCAL/*/aliases.sh $SHELLRC_PLUGINS_DIR_LOCAL/*/private/aliases.sh | \
    command cat $SHELLRC_PLUGINS_DIR_LOCAL/*/aliases.sh \
        | awk '
            BEGIN { 
            }
    
            /^# %/        { r = $0; sub(/^# /, "", r); print r; next }
            /^# #/        { r = $0; sub(/^# /, "", r); print r; next }
            /^# ;/        { r = $0; sub(/^# ; usage: /, "", r); print r; next }
            !/^# (%|#|;)/ { next }
            /^$/          { next }
            /^alias/      { next }
                          { print }
    
            END {
            }
        ' >$PERSO_CHEAT_FILE
}
