export HOMEBREW_NO_ANALYTICS=1

# Upgrade homebrew managed pakcages

HOMEBREW_PACKAGES_UPDATED="/tmp/${USER}_homebrew_packages_updated"
HOMEBREW_PACKAGES_UPGRADE_SCRIPT="/tmp/${USER}_homebrew_packages_upgrade.sh"
HOMEBREW_PACKAGES_UPGRADE_LOG="/tmp/${USER}_homebrew_packages_upgrade.log"

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

cat <<EOF > "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT"
    brew update 2>&1;

    # Uninstall previous non cask and cask package versions (to save on disk space over time)
    brew cleanup 2>&1;
    # brew cask cleanup now depecrated. brew cleanup must be used instead 

    # Upgrade non cask and cask brew packages
    # - upgrade non casks
    brew upgrade 2>&1;
    # - upgrade cask with explicitly version
    brew cask upgrade --force 2>&1;
    # - upgrade cask with "lastest" version or "auto_updates"
    #   These are upgraded every 4 weeks
    weeknumber=`date +%V`;
    reminder=$(( $weeknumber % 4 ))
    [ $reminder -eq 0 ] && brew cask upgrade --greedy --force 2>&1;

    touch "$HOMEBREW_PACKAGES_UPDATED"
    chmod 777 "$HOMEBREW_PACKAGES_UPDATED"
    rm -f "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT"
EOF

rm -f "$HOMEBREW_PACKAGES_UPGRADE_LOG" > /dev/null 2>&1

bash "$HOMEBREW_PACKAGES_UPGRADE_SCRIPT" > "$HOMEBREW_PACKAGES_UPGRADE_LOG" 2>&1 &

fi
