# Upgrade python managed global pakcages

PYTHON_PACKAGES_UPDATED="/tmp/$USER_python_packages_updated"
PYTHON_PACKAGES_UPGRADE_SCRIPT="/tmp/$USER_homebrew_python_upgrade.sh"
PYTHON_PACKAGES_UPGRADE_LOG="/tmp/$USER_python_packages_upgrade.log"

# Force packages upgrades every 1d
if [ -f "$PYTHON_PACKAGES_UPDATED" ];
then
    ts1=$(stat -c %Y "$PYTHON_PACKAGES_UPDATED"); 
    now=$(date '+%s'); 
    ts2=$(($now - 3600*24*1)); # 3600*24*1 = 1 day 
    if [ $ts1 -lt $ts2 ];
    then 
        rm -f "$PYTHON_PACKAGES_UPDATED" > /dev/null 2>&1;
    fi
fi

# Upgrade packages when required
if [ ! -f "$PYTHON_PACKAGES_UPDATED" ] && [ ! -f "$python_PACKAGES_UPGRADE_SCRIPT" ];
then

cat <<EOF > "$PYTHON_PACKAGES_UPGRADE_SCRIPT"
    # Install tool to easily upgrade python packages
    pip2 install pip_upgrade_outdated
    pip3 install pip_upgrade_outdated
    # Upgrade python packages, meeting other packages depedencies
    pip_upgrade_outdated -2 -s  # Python 2 support
    pip_upgrade_outdated -3 -s  # Python 3 support

    touch "$PYTHON_PACKAGES_UPDATED"
    chmod 777 "$PYTHON_PACKAGES_UPDATED"
    rm -f "$PYTHON_PACKAGES_UPGRADE_SCRIPT"
EOF

rm -f "$PYTHON_PACKAGES_UPGRADE_LOG" > /dev/null 2>&1

bash "$PYTHON_PACKAGES_UPGRADE_SCRIPT" > "$python_PACKAGES_UPGRADE_LOG" 2>&1 &

fi
