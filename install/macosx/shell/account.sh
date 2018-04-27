###############################################################################
# Account related functions
###############################################################################

DSCL='/usr/bin/dscl'
SECURITY='/usr/bin/security'

# param1: current user
function account_has_administration_permission() {
    # Can use sudo
    #sudo ${SUDO_OPTIONS} echo >> /dev/null
    sudo -n true
    [[ $? -eq 0 ]] && return 0
    # Has admin group
    groups | grep "\(^\| \)admin\( \|$\)" && return 0
    return 1 
}

# param1: user
# param2: group
function account_user_remove_group() {
    sudo ${SUDO_OPTIONS} dseditgroup -o edit -d "$1" -t user "$2" 
}

#param1: username
function account_exists() {
    local USERNAME="$1"
    $DSCL . read /Users/$USERNAME >/dev/null 2>&1 && return 0 || return 1
}

# param1: username
# param2: real name
# param3: password
function account_admin_create() {
    local USERNAME="$1"
    local REALNAME="$2"
    local PASSWORD="$3"

    sudo ${SUDO_OPTIONS} $DSCL . create /Users/${USERNAME}
    sudo ${SUDO_OPTIONS} $DSCL . create /Users/${USERNAME} RealName "${REALNAME}"
    sudo ${SUDO_OPTIONS} $DSCL . create /Users/${USERNAME} hint ""
    #sudo ${SUDO_OPTIONS} $DSCL . create /Users/administrator picture "/Path/To/Picture.png"
    sudo ${SUDO_OPTIONS} $DSCL . passwd /Users/${USERNAME} ${PASSWORD}
    sudo ${SUDO_OPTIONS} $DSCL . create /Users/${USERNAME} UniqueID 550
    sudo ${SUDO_OPTIONS} $DSCL . create /Users/${USERNAME} PrimaryGroupID 80      # 80 = Admin User   20 = Regular User
    #dudo ${SUDO_OPTIONS} $DSCL . append /Groups/admin GroupMembership corybohon
    sudo ${SUDO_OPTIONS} $DSCL . create /Users/${USERNAME} UserShell /bin/bash
    sudo ${SUDO_OPTIONS} $DSCL . create /Users/${USERNAME} NFSHomeDirectory /Users/${USERNAME}
    sudo ${SUDO_OPTIONS} cp -R /System/Library/User\ Template/English.lproj /Users/${USERNAME}
    sudo ${SUDO_OPTIONS} chown -R ${USERNAME}:staff /Users/${USERNAME}
}

function account_guest_enable {
	# Does guest already exist?
	if [ -f /var/db/dslocal/nodes/Default/users/Guest.plist ]; then
		echo "Guest already created!"
		exit 0
	else
		# Lion+ has a different procedure for enabling the guest account
		if [ "$(sw_vers | grep -o '10\.6')" != "" ]; then
			logger -s "$0: Not implemented"

			exit 0
		fi

		# Lion+ procedure
		if [ "$(sw_vers | grep -o '10\.[7-8]')" != "" ]; then
			logger "$0: Enabling 10.7/10.8 Guest"
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest dsAttrTypeNative:_defaultLanguage en
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest dsAttrTypeNative:_guest true
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest dsAttrTypeNative:_writers__defaultLanguage Guest
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest dsAttrTypeNative:_writers__LinkedIdentity Guest
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest dsAttrTypeNative:_writers__UserCertificate Guest
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest AuthenticationHint ''
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest NFSHomeDirectory /Users/Guest

			# Give a little extra time for the password and kerberos to play nicely
			sleep 2
			sudo ${SUDO_OPTIONS} $DSCL . -passwd /Users/Guest ''
			sleep 2

			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest Picture "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/UserIcon.icns"
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest PrimaryGroupID 201
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest RealName "Guest User"
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest RecordName Guest
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest UniqueID 201
			sudo ${SUDO_OPTIONS} $DSCL . -create /Users/Guest UserShell /bin/bash
			sudo ${SUDO_OPTIONS} $SECURITY add-generic-password -a Guest -s com.apple.loginwindow.guest-account -D "application password" /Library/Keychains/System.keychain
			
			# This seems to be technically unnecessary; it controls whether the "Allow 
			# guests to log in to this computer" checkbox is enabled in SysPrefs 
			sudo ${SUDO_OPTIONS} defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool TRUE

			# Profiles created with PM have these two keys, but they don't seem to do 
			# anything 
			#sudo ${SUDO_OPTIONS} defaults write /Library/Preferences/com.apple.loginwindow DisableGuestAccount -bool FALSE
			#sudo ${SUDO_OPTIONS} defaults write /Library/Preferences/com.apple.loginwindow EnableGuestAccount -bool TRUE

			logger -s "$0: Guest created"

			exit 0
		fi
	fi
}


function account_guest_disable {
	sudo ${SUDO_OPTIONS} $DSCL . -delete /Users/Guest
	sudo ${SUDO_OPTIONS} $SECURITY delete-generic-password -a Guest -s com.apple.loginwindow.guest-account -D "application password" /Library/Keychains/System.keychain

	# Also-do we need this still? (Should un-tick the box)
	sudo ${SUDO_OPTIONS} defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool FALSE

	# Doesn't have an effect, but here for reference
	#sudo ${SUDO_OPTIONS} defaults write /Library/Preferences/com.apple.loginwindow DisableGuestAccount -bool TRUE
	#sudo ${SUDO_OPTIONS} defaults write /Library/Preferences/com.apple.loginwindow EnableGuestAccount -bool FALSE

	logger -s "$0: Guest account disabled"

	exit 0
}

