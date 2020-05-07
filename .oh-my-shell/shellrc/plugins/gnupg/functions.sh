# shellcheck disable=SC2181,2155,SC2039

# Utility functions to create "perfect" master key / sub key

# Create master key with passphrase
# Usage: function "John Doe" "me@example.com" "1y" "capabilities" "passphrase" "/path/to/random/file.conf"
gnupg_create_recommended_master_key() {
    # Create key
    local LOCAL_GNUPGHOME="$1"
    local name="$2"
    local email="$3"
    local duration="$4"
    local algo="$5"
    local capabilities="$6"
    local passphrase="$7"
    local conffile="${8:-"$LOCAL_GNUPGHOME/tmp_create_master_key_config.conf"}"
    local statusfile="$LOCAL_GNUPGHOME/tmp_create_master_key-$name-$email-$duration-$algo-$capabilities.status"


cat >"$conffile" <<EOF
        %echo Master GPG key: Begin generating
        Key-Type: eddsa
        Key-Curve: $algo
        Key-Usage: $capabilities
        Name-Real: $name
        Name-Email: $email
        Expire-Date: $duration
        Passphrase: $passphrase
        # Do a commit here, so that we can later print "done" :-)
        %commit
        %echo Master GPG key: Completed 
EOF

    GNUPGHOME="$LOCAL_GNUPGHOME" gpg --options "$HOME/.gnupg/gpg.conf" \
        --quiet \
        --no-verbose \
        --batch \
        --status-file "$statusfile" \
        --full-gen-key "$conffile"

        #--faked-system-time "20010101T010101!" 

    masterKeyFingerprint=$(GNUPGHOME="$LOCAL_GNUPGHOME" gpg --list-options show-only-fpr-mbox --list-secret-keys | awk '{print $1}')
    echo "$masterKeyFingerprint"
}

gnupg_create_recommended_sub_key() {
    local LOCAL_GNUPGHOME="$1"
    local masterKeyFingerprint="${2:-NONE}"
    local name="$3"
    local email="$4"
    local duration="$5"
    local algo="$6"
    local capabilities="$7"
    local passphrase="$8"
    local statusfile="$LOCAL_GNUPGHOME/tmp_create_sub_key-$name-$email-$duration-$algo-$capabilities.status"

    GNUPGHOME="$LOCAL_GNUPGHOME" gpg --options "$HOME/.gnupg/gpg.conf" \
        --quiet \
        --no-verbose \
        --batch \
        --pinentry-mode loopback --passphrase-fd 0 \
        --status-file "$statusfile" \
        --quick-add-key "$masterKeyFingerprint" "$algo" "$capabilities" "$duration" <<<"$passphrase"

        #--faked-system-time "20010101T010101!" 

    subKeyFingerprint=$(grep "KEY_CREATED" "$statusfile" | cut -d ' ' -f 4)
    echo "$subKeyFingerprint"
}

gnupg_lint_key() {
    # Use hopenpgp-tools to verify generated keys follow best practices
    local LOCAL_GNUPGHOME="$1"
    local fingerprint="$2"

    GNUPGHOME="$LOCAL_GNUPGHOME" gpg --options "$HOME/.gnupg/gpg.conf" \
        --export "$fingerprint" | hokey lint

    # Note: 
    # - hokey does not support ECC key well yet: FIXE https://github.com/riseupnet/riseup_help/issues/451
    # - only signing subkey requires embedded cross certification with master key (https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=blob;f=g10/keyedit.c;h=1456d286784d32b43d96aa19a9c8b923e2b49a83;hb=e926f30a1cda75f6334b79c303b5134f0441a3dc#l5091)
}

gnupg_create_revocation_certificate_for_key() {
    # Inspiration: https://github.com/mgorny/gen-revoke/blob/master/gen-revoke.bash

    local LOCAL_GNUPGHOME2="$1"
    local LOCAL_GNUPGHOME2_REVOCS_DIR="$2"

    local LOCAL_GNUPGHOME="$3"
    local LOCAL_GNUPGHOME_REVOCS_DIR="$4"

    local key="$5"
    local isMasterKey="$6"
    local passphrase="$7"

    local fingerprint="$key"

    if [[ ${isMasterKey} == 1 ]]; then
		subkey=0
		exp_confirm='Do you really want to revoke the entire key?'
	else
		subkey=${key}
		exp_confirm='Do you really want to revoke this subkey?'
	fi

	# Note: Use expect -d to debug execution
	GNUPGHOME="${LOCAL_GNUPGHOME2}" expect  - <<-EOF > /dev/null 2>&1
		set timeout -1
		match_max 100000
		spawn gpg --options "$HOME/.gnupg/gpg.conf" --edit-key ${key}
		expect "gpg>"
		send "key ${subkey}\n"
		expect {
			"No subkey with key ID" {
				exit 1
			}
			"gpg>" {
				send "revkey\n"
				expect "${exp_confirm}"
				send "y\n"
				expect "Your decision?"
				send "0\n"
				expect ">"
				send "None\n"
				send "\n"
				expect "Is this okay?"
				send "y\n"
				expect "gpg>"
				send "minimize\n"
				expect "gpg>"
				send "save\n"
				sleep 2
			}
		}
	EOF

    [ "$?" -ne "0" ] && echo "ERROR: key revocation failed: $fingerprint" && return 1

    local fileCert="$LOCAL_GNUPGHOME2_REVOCS_DIR/$fingerprint.rev"
    local keyBlock="$(GNUPGHOME="${LOCAL_GNUPGHOME2}" gpg --armor --export "$fingerprint")"

    printf "This is a revocation certificate for the OpenPGP key:\
            \n\nsub %s\
            \n\nTo avoid an accidental use of this file, remove the colon before\
            \nthe 5 dashes below, before importing and publishing this revocation\
            \ncertificate\
            \n\n:%s" \
            "$fingerprint" "$keyBlock" > "$fileCert"
    command cp "$fileCert" "$LOCAL_GNUPGHOME_REVOCS_DIR/"
	return $?
}

# Create master + sub key with distinct capabilities, with revocation certificate 
# as well as following best practices
# 
# Usage: function "John Doe" "john@example.com" "1y"
#
# Inspiration: 
# - master key/sub key: 
# -- https://gist.github.com/fervic/ad30e9f76008eade565be81cef2f8f8c
# -- https://www.alessandromenti.it/blog/2017/01/transitioning-new-gpg-keypair.html
# -- https://blog.eleven-labs.com/en/openpgp-almost-perfect-key-pair-part-1/
# -- https://alexcabal.com/creating-the-perfect-gpg-keypair
# - misc:
# -- https://gist.github.com/fervic/ad30e9f76008eade565be81cef2f8f8c
gnupg_create_CSEA_key() {
    tmpDir="$(f_create_ramfs 10)"
    ( sleep 900s; f_delete_ramfs "$tmpDir" ) &
    local OUT="$tmpDir/out"

    local DAILY_GNUPGHOME="$HOME/.gnupg"
    local DAILY_GNUPGHOME_REVOCS_DIR="$DAILY_GNUPGHOME/openpgp-revocs.d"
    mkdir -p "$DAILY_GNUPGHOME_REVOCS_DIR"

    # Use ephermeral directory for key manipulation, away from daily keyring
    local LOCAL_GNUPGHOME="$(mktemp -d --tmpdir="$tmpDir")"
    local LOCAL_GNUPGHOME_REVOCS_DIR="$LOCAL_GNUPGHOME/openpgp-revocs.d"

    local LOCAL_GNUPGHOME2="$(mktemp -d --tmpdir="$tmpDir")"
    local LOCAL_GNUPGHOME2_REVOCS_DIR="$LOCAL_GNUPGHOME2/openpgp-revocs.d"

    local name="${1:-John Doe}"
    local email="${2:-john.doe@example.com}"
    local duration="${3:-1y}"
    local keyPairAlgo="${4:-ed25519}"
    local keyPairAlgo2="${5:-cv25519}"
    local confirmStep="${6:-0}"
    local stopOnFailure="${7:-0}"
    local importIntoDailyKeyring="${8:-0}"
    local passphrase=""

    echo "Set the master key's + sub keys passphrase:"
    echo "NOTE: You will be asked for the passphrase several times."
    read -r -s  passphrase

    # Master key: certify all sub-keys only
    local masterKeyFingerprint=$(gnupg_create_recommended_master_key "$LOCAL_GNUPGHOME"                        "$name" "$email" "$duration" "$keyPairAlgo" "cert" "$passphrase")
    # Sub-key 1: sign only
    local subkeyFingerprint1=$(gnupg_create_recommended_sub_key      "$LOCAL_GNUPGHOME" "$masterKeyFingerprint" "$name" "$email" "$duration" "$keyPairAlgo" "sign" "$passphrase")
    # Sub-key 1: encrypt only
    local subkeyFingerprint2=$(gnupg_create_recommended_sub_key      "$LOCAL_GNUPGHOME" "$masterKeyFingerprint" "$name" "$email" "$duration" "$keyPairAlgo2" "encrypt" "$passphrase")
    # Sub-key 1: authenticate only
    local subkeyFingerprint3=$(gnupg_create_recommended_sub_key      "$LOCAL_GNUPGHOME" "$masterKeyFingerprint" "$name" "$email" "$duration" "$keyPairAlgo" "auth" "$passphrase")

    # Lint master + sub keys
    gnupg_lint_key "$LOCAL_GNUPGHOME" "$masterKeyFingerprint"

    if [ "$confirmStep" -eq "0" ];
    then
        echo "Confirmation: gpg keys setup (above)."
        echo " - GREEN values: Best practice followed"
        echo " - RED values: Potential security issue"
        echo "Press any ENTER to continue. Ctrl-C to cancel"
        read -r
    fi

    # List master + sub keys
    #GNUPGHOME="$LOCAL_GNUPGHOME" gpg \
    #    --options "$HOME/.gnupg/gpg.conf" \
    #    --list-keys

    # Verify all keys have been created
    countMasterKey=$(GNUPGHOME="$LOCAL_GNUPGHOME" gpg --options "$HOME/.gnupg/gpg.conf" --list-keys | grep -c "^pub")
    countSubKey=$(GNUPGHOME="$LOCAL_GNUPGHOME" gpg --options "$HOME/.gnupg/gpg.conf" --list-keys | grep -c "^sub")

    [ "$stopOnFailure" -eq "0" ] && [ "$countMasterKey" -ne "1" ] && echo "ERROR: master key not generated" && return
    [ "$stopOnFailure" -eq "0" ] && [ "$countSubKey" -ne "3" ] && echo "ERROR: 1+ subkey not generated" && return

    # Generate revocation certificate for the master/sub keys, in openpgp-revocs.d
    (command cp -R "$LOCAL_GNUPGHOME/." "$LOCAL_GNUPGHOME2/" && mkdir -p "$LOCAL_GNUPGHOME2_REVOCS_DIR") >/dev/null 2>&1
    # Note: Master key revocation certificate ALREADY GENERATED WITH gnupg_create_recommended_master_key
    for fingerprint in "$subkeyFingerprint1" "$subkeyFingerprint2" "$subkeyFingerprint3"
    do
        gnupg_create_revocation_certificate_for_key \
            "$LOCAL_GNUPGHOME2" "$LOCAL_GNUPGHOME2_REVOCS_DIR" \
            "$LOCAL_GNUPGHOME" "$LOCAL_GNUPGHOME_REVOCS_DIR" \
            "$fingerprint" 0 "$passphrase"
        [ "$?" -ne "0" ] && return
    done

    local masterKeyRevocationCert="$LOCAL_GNUPGHOME_REVOCS_DIR/$masterKeyFingerprint.rev"
    local subKeyRevocationCert1="$LOCAL_GNUPGHOME_REVOCS_DIR/$subkeyFingerprint1.rev"
    local subKeyRevocationCert2="$LOCAL_GNUPGHOME_REVOCS_DIR/$subkeyFingerprint2.rev"
    local subKeyRevocationCert3="$LOCAL_GNUPGHOME_REVOCS_DIR/$subkeyFingerprint3.rev"

    # Verify all revocation certificates have been created
    [ "$stopOnFailure" -eq "0" ] && [ ! -f "$masterKeyRevocationCert" ] && \
        echo "ERROR: Revocation cert for master key $masterKeyFingerprint not generated: $masterKeyRevocationCert" && \
        return
    [ "$stopOnFailure" -eq "0" ] && [ ! -f "$subKeyRevocationCert1" ] && \
        echo "ERROR: Revocation cert for sub key $masterKeyFingerprint/$subKeyRevocationCert1 not generated: $subKeyRevocationCert1" && \
        return
    [ "$stopOnFailure" -eq "0" ] && [ ! -f "$subKeyRevocationCert2" ] && \
        echo "ERROR: Revocation cert for sub key $masterKeyFingerprint/$subKeyRevocationCert2 not generated: $subKeyRevocationCert2" && \
        return
    [ "$stopOnFailure" -eq "0" ] && [ ! -f "$subKeyRevocationCert3" ] && \
        echo "ERROR: Revocation cert for sub key $masterKeyFingerprint/$subKeyRevocationCert3 not generated: $subKeyRevocationCert3" && \
        return

    local secretKeysFile="$PWD/$masterKeyFingerprint-master_and_subs_secret-keys.asc"
    local publicKeysFile="$PWD/$masterKeyFingerprint-master_and_subs-public-keys.asc"

    # Export public keys only (master + all subs) as backup
    GNUPGHOME="$LOCAL_GNUPGHOME" gpg --options "$HOME/.gnupg/gpg.conf" \
        --export --armor \
        --output "$publicKeysFile" "$masterKeyFingerprint" > /dev/null 2>&1

    # Export secret keys only (master + all subs) as backup
    GNUPGHOME="$LOCAL_GNUPGHOME" gpg --options "$HOME/.gnupg/gpg.conf" \
        --export-secret-keys --armor \
        --output "$secretKeysFile" "$masterKeyFingerprint" > /dev/null 2>&1

    # Change master + sub key passphrase
    # FIXME

    # Move all important artefacts (keys)
    mkdir -p "$OUT" && \
        command mv "$secretKeysFile"          "$OUT/"   && \
        command mv "$publicKeysFile"          "$OUT/"

    secretKeysFile="$OUT/$(basename "$secretKeysFile")"
    publicKeysFile="$OUT/$(basename "$publicKeysFile")"

    # Verify all public / private keys have been exported 
    for fingerprint in "$masterKeyFingerprint" "$subkeyFingerprint1" "$subkeyFingerprint2" "$subkeyFingerprint3"
    do
        # Public keys
        GNUPGHOME="$LOCAL_GNUPGHOME" gpg --options "$HOME/.gnupg/gpg.conf" \
            --with-fingerprint --with-subkey-fingerprint --with-colons "$publicKeysFile" 2>&1 | \
            grep "$fingerprint" > /dev/null 2>&1
        [ "$?" -ne "0" ] && [ "$stopOnFailure" -eq "0" ] && echo "ERROR: Exported public key missing: $fingerprint" && return 

        # Private keys
        GNUPGHOME="$LOCAL_GNUPGHOME" gpg --options "$HOME/.gnupg/gpg.conf" \
            --with-colons --import-options show-only --import --fingerprint \
            < "$secretKeysFile" 2>&1 | \
            grep "$fingerprint" > /dev/null 2>&1
        [ "$?" -ne "0" ] && [ "$stopOnFailure" -eq "0" ] && echo "ERROR: Exported private key missing: $fingerprint" && return 
    done

    # Verify all revocation certificates have been exported
    for cert in "$masterKeyRevocationCert" "$subKeyRevocationCert1" "$subKeyRevocationCert2" "$subKeyRevocationCert3"
    do
        command mv "$cert" "$OUT/"
        [ "$?" -ne "0" ] && [ "$stopOnFailure" -eq "0" ] && echo "ERROR: Exported revocation cert missing $cert" && return
    done

    masterKeyRevocationCert="$OUT/$(basename "$masterKeyRevocationCert")"
    subKeyRevocationCert1="$OUT/$(basename "$subKeyRevocationCert1")"
    subKeyRevocationCert2="$OUT/$(basename "$subKeyRevocationCert2")"
    subKeyRevocationCert3="$OUT/$(basename "$subKeyRevocationCert3")"

    # Import keys into daily keyring
    # FIXME: https://github.com/torvalds/linux/blob/master/Documentation/process/maintainer-pgp-guide.rst
    # FIXME: https://rudd-o.com/linux-and-free-software/protecting-your-private-master-key-in-gnupg-2-1-and-later
    # FIXME: https://cheatsheets.chaospixel.com/gnupg/
    if [ "$importIntoDailyKeyring" -eq "0" ]; 
    then
        # Import keys
        echo "Importing newly created public+secret master/sub keys into $HOME/.gnupg default keyring"
        GNUPGHOME="$DAILY_GNUPGHOME" gpg --import "$publicKeysFile" 
        [ "$?" -ne "0" ] && [ "$stopOnFailure" -eq "0" ] && echo "ERROR: Importing new public master/sub keys into $DAILY_GNUPGHOME: $publicKeysFile" && return 
        GNUPGHOME="$DAILY_GNUPGHOME" gpg --import "$secretKeysFile"
        [ "$?" -ne "0" ] && [ "$stopOnFailure" -eq "0" ] && echo "ERROR: Importing new private master/sub keys into $DAILY_GNUPGHOME: $secretKeysFile" && return 

        # Import revocation certificates
        for cert in "$masterKeyRevocationCert" "$subKeyRevocationCert1" "$subKeyRevocationCert2" "$subKeyRevocationCert3"
        do
            command cp "$cert" "$DAILY_GNUPGHOME_REVOCS_DIR/"
            [ "$?" -ne "0" ] && [ "$stopOnFailure" -eq "0" ] && echo "ERROR: Importing revocation cert $cert into $DAILY_GNUPGHOME" && return
        done
    else
       echo "Generated master + sub keys available at $LOCAL_GNUPGHOME"
       echo "This directory is a RAM backed directory. Press ENTER to wipe out"
       echo "Suggestion: Copy the directory elsewhere to not loose the generated keys"
       read -r 
    fi

    #
    # Laptop key mode (master key + sub keys, with master skey secret removed) ?
    # FIXME - https://spin.atomicobject.com/2013/11/24/secure-gpg-keys-guide/
}

# FIXME create utility functions to publish sub keys
# FIXME create utility functions to sign a key
# FIXME create utility functions to trust a key
# FIXME create utility functions to revoke a key signature
# FIXME create utility functions to revoke a key
# FIXME create utility functions to sig  git commit (always, one off)
# FIXME setup mutt with pgp
# - All these above are documented at: 
# - https://thoughtbot.com/blog/pgp-and-you

# FIXME nonintercative publish/trust keys
# - https://raymii.org/s/articles/GPG_noninteractive_batch_sign_trust_and_send_gnupg_keys.html

# FIXME create utility functions to Encrypt/decrypt files
# - https://wojnowski.net.pl/main/index/symmetric-and-asymmetric-key-encryption-with-gpg-and-gpg-zip

# FIXME Use gpg-agent better
# - SSH compatibility ? https://blogs.gentoo.org/mgorny/2018/05/12/on-openpgp-gnupg-key-management/
# -- https://www.gnupg.org/documentation/manuals/gnupg/Agent-Examples.html#Agent-Examples
# - https://eklitzke.org/using-gpg-agent-effectively
# - https://unix.stackexchange.com/a/188813/45954

# Use text pinentry preferably over GUI pinentry
# - https://kevinlocke.name/bits/2019/07/31/prefer-terminal-for-gpg-pinentry/

###
# Useful
###

# Delete all keys in a keychain, unattended
# cat <(gpg -K) <(gpg -k) | grep -A1 "ssb\|sec" | sed '/^--$/d' | grep --invert-match "ssb\|sec" | sed '/^--$/d' | xargs -n1 -I {} gpg --batch --yes --delete-keys {} \;

# Encrypt file
#echo "TEST" > file.txt; gpg --output file.gpg --encrypt --recipient david@andreoletti.net file.txt; 

# Sign content to be encrypted
#shasum -a 256 file.txt | awk '{print $1}' > file.txt.sha256sum; gpg --output file.txt.sha256sum.sig --sign file.txt.sha256sum; cat file.txt.sha256sum; 

# Decrypt file
#rm file.txt; gpg --output file.txt --decrypt file.gpg;

# Verify decrypted file was not compromised
#cat file.txt; gpg --verify file.txt.sha256sum.sig


