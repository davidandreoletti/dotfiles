# Upgrade npm managed global pakcages

NPM_PACKAGES_UPDATED="/tmp/${USER}_npm_packages_upgrade"
NPM_PACKAGES_UPGRADE_SCRIPT="/tmp/${USER}_npm_packages_upgrade.sh"
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
    set -x

    # Load nvm
    . `brew --prefix nvm`/nvm.sh
    # Use the most recent LTS node version installed by default (in case nvm encounters incomaptible options such as npm prefix option being set)
    nvm use --delete-prefix --lts --silent
    which node
    which npm

    #Upgrade npm itself
    npm install -g npm@latest

    #Upgrade npm list global outdated"
    npm outdated -g --depth=0

    npm update -g
    # Cache verify requires npm 5+
    npm cache verify
    npm doctor

    touch "$NPM_PACKAGES_UPDATED"
    chmod 777 "$NPM_PACKAGES_UPDATED"
    rm -f "$NPM_PACKAGES_UPGRADE_SCRIPT"

    set +x
EOF

rm -f "$NPM_PACKAGES_UPGRADE_LOG" > /dev/null 2>&1

( bash "$NPM_PACKAGES_UPGRADE_SCRIPT" > "$NPM_PACKAGES_UPGRADE_LOG" 2>&1 & )

fi

