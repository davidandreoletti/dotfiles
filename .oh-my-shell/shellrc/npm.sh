# Upgrade npm managed global pakcages

NPM_PACKAGES_UPDATED="/tmp/${USER}_npm_packages_updated"
NPM_PACKAGES_UPGRADE_SCRIPT="/tmp/${USER}_homebrew_npm_upgrade.sh"
NPM_PACKAGES_UPGRADE_LOG="/tmp/${USER}_npm_packages_upgrade.log"

# Force packages upgrades every 1d
if [ -f "$NPM_PACKAGES_UPDATED" ];
then
    ts1=$(stat -c %Y "$NPM_PACKAGES_UPDATED"); 
    now=$(date '+%s'); 
    ts2=$(($now - 3600*24*1)); # 3600*24*1 = 1 day 
    if [ $ts1 -lt $ts2 ];
    then 
        rm -f "$NPM_PACKAGES_UPDATED" > /dev/null 2>&1;
    fi
fi

# Upgrade packages when required
if [ ! -f "$NPM_PACKAGES_UPDATED" ] && [ ! -f "$NPM_PACKAGES_UPGRADE_SCRIPT" ];
then

cat <<EOF > "$NPM_PACKAGES_UPGRADE_SCRIPT"
    #Upgrade npm itself
    npm install npm@latest -g

    #Upgrade npm list global outdated"
    npm outdated -g --depth=0

    npm update -g
    npm cache clean
    npm cache verify
    npm doctor

    touch "$NPM_PACKAGES_UPDATED"
    chmod 777 "$NPM_PACKAGES_UPDATED"
    rm -f "$NPM_PACKAGES_UPGRADE_SCRIPT"
EOF

rm -f "$NPM_PACKAGES_UPGRADE_LOG" > /dev/null 2>&1

bash "$NPM_PACKAGES_UPGRADE_SCRIPT" > "$NPM_PACKAGES_UPGRADE_LOG" 2>&1 &

fi
