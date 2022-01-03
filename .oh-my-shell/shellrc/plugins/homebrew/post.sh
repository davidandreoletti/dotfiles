# Upgrade homebrew managed packages

HOMEBREW_PACKAGES_UPDATED="/tmp/${USER}_homebrew_packages_upgraded"
HOMEBREW_PACKAGES_UPGRADE_SCRIPT="/tmp/${USER}_homebrew_packages_upgrade.sh"
HOMEBREW_PACKAGES_UPGRADE_LOG="/tmp/${USER}_homebrew_packages_upgrade.log"

function upgradeBrewPackagesInBackground () {

cat <<EOF > "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT"
    set -x

    brew update 2>&1;

    # Uninstall previous non cask and cask package versions (to save on disk space over time)
    # Note: brew cask cleanup now deprecated. brew cleanup must be used instead 
    brew cleanup 2>&1;

    # Upgrade non cask packages
    # - upgrade non casks
    brew upgrade 2>&1;

    touch "$HOMEBREW_PACKAGES_UPDATED"
    chmod 777 "$HOMEBREW_PACKAGES_UPDATED"
    rm -f "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT"

    set +x
EOF

bash "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT" > "$HOMEBREW_PACKAGES_UPGRADE_LOG" 2>&1 &

}

function upgradeBrewPackagesInForeground () {

cat <<EOF > "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT"
    weeknumber=\`date +%V\`;
    reminder="\$weeknumber % 4"
    if [ \`echo "\$reminder" | bc\` -eq 0 ];
    then
        echo "Brew cask packages last upgraded 4+ weeks ago. Upgrading now. Ctrl-C to cancel"
        # Upgrade cask packages
        # - upgrade cask with explicitly version
        brew cask upgrade --force 2>&1;
        # - upgrade cask with "lastest" version or "auto_updates"
        brew cask upgrade --greedy --force 2>&1;
        # Free spaces by removing old versions, logs, etc
        brew cleanup --prune=all
    fi 
EOF

source "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT" | tee "$HOMEBREW_PACKAGES_UPGRADE_LOG"

}

function isCurrentUserHomebrewCellarDirectoryOwner () {
	local fileOrDirPath="$1"
	local resourceOwner="$(stat -c '%U' $fileOrDirPath)"

	[ "$USER" = "$resourceOwner" ]
}

# Force packages upgrades every 1d
if [ -f "$HOMEBREW_PACKAGES_UPDATED" ];
then
    ts1=$(stat -c %Y "$HOMEBREW_PACKAGES_UPDATED"); 
    now=$(date '+%s'); 
    ts2=$(($now - 3600*24*1)); # 3600*24*1 = 1 day 
    if [ $ts1 -lt $ts2 ];
    then 
        rm -f "$HOMEBREW_PACKAGES_UPDATED" > /dev/null 2>&1;
    fi
fi

# Upgrade packages when required
if [ ! -f "$HOMEBREW_PACKAGES_UPDATED" ] && [ ! -f "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT" ];
then
    rm -f "$HOMEBREW_PACKAGES_UPGRADE_LOG" > /dev/null 2>&1
    isCurrentUserHomebrewCellarDirectoryOwner "$(brew --prefix)/Cellar" && upgradeBrewPackagesInForeground
    isCurrentUserHomebrewCellarDirectoryOwner "$(brew --prefix)/Cellar" && upgradeBrewPackagesInBackground
fi
