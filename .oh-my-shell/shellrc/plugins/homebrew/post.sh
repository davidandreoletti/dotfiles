# Upgrade homebrew managed packages

HOMEBREW_POST_BASE="$HOME/.oh-my-shell/tmp/homebrew_post"
HOMEBREW_POST_MARKER="$HOMEBREW_POST_BASE.marker"

HOMEBREW_PACKAGES_UPGRADE_SCRIPT="$HOMEBREW_POST_BASE.package_upgrade.sh"
HOMEBREW_PACKAGES_UPGRADE_LOG="$HOMEBREW_PACKAGES_UPGRADE_SCRIPT.log"
HOMEBREW_PACKAGES_UPGRADE_SCRIPT2="$HOMEBREW_POST_BASE.package_upgrade2.sh"
HOMEBREW_PACKAGES_UPGRADE_LOG2="$HOMEBREW_PACKAGES_UPGRADE_SCRIPT2.log"


# 3600*24*30 = 30 days
if f_run_every_x_seconds "$HOMEBREW_POST_MARKER" "$((3600*24*30))" ;
then

function f_isCurrentUserHomebrewCellarDirectoryOwner () {
	local fileOrDirPath="$1"
	
	local resourceOwner="$(stat -c '%U' $fileOrDirPath)"

	[ "$USER" = "$resourceOwner" ]
}

cat <<EOF > "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT"
    brew update 2>&1;

    # Uninstall previous non cask and cask package versions (to save on disk space over time)
    # Note: brew cask cleanup now deprecated. brew cleanup must be used instead 
    brew cleanup 2>&1;

    # Upgrade non cask packages
    # - upgrade non casks
    brew upgrade 2>&1;
EOF

cat <<EOF > "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT2"
    weeknumber=\`date +%V\`;
    reminder="\$weeknumber % 4"
    if [ \`echo "\$reminder" | bc\` -eq 0 ];
    then
        echo "Brew cask packages last upgraded 4+ weeks ago. Upgrading now. Ctrl-C to cancel"
        # Upgrade cask packages
        # - upgrade cask with explicitly version
        [ "$OS_TYPE" == "macos" ] && brew upgrade --cask --force 2>&1;
        # - upgrade cask with "lastest" version or "auto_updates"
        [ "$OS_TYPE" == "macos" ] && brew upgrade --cask --greedy --force 2>&1;
        # Free spaces by removing old versions, logs, etc
        brew cleanup --prune=all
    fi 
EOF

    # case: macos
    cellarDir="$(brew --prefix)/Cellar"
    # case: linux
    [ ! -d "$cellarDir" ] && cellarDir="$(brew --prefix)/../Cellar"

    if f_isCurrentUserHomebrewCellarDirectoryOwner "$cellarDir";
    then
        f_run_exclusive_with_completion "${HOMEBREW_PACKAGES_UPGRADE_SCRIPT2}.lockfile" "$HOMEBREW_PACKAGES_UPGRADE_LOG2" "$HOMEBREW_POST_MARKER" bash $HOMEBREW_PACKAGES_UPGRADE_SCRIPT2
    else
        f_run_exclusive_in_background_with_completion "${HOMEBREW_PACKAGES_UPGRADE_SCRIPT}.lockfile" "$HOMEBREW_PACKAGES_UPGRADE_LOG" "$HOMEBREW_POST_MARKER" bash $HOMEBREW_PACKAGES_UPGRADE_SCRIPT
    fi
fi
