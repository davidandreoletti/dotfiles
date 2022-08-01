# Always install the latest python version per MAJOR.MINOR group
( ( for v in 3.8 3.9 3.10; do echo "Installing $v" >> /tmp/foo.txt ;pyenv install --skip-existing "${v}:latest"; done ) & )

PYTHON_PACKAGES_UPDATED="/tmp/${USER}_python_packages_updated"
PYTHON_PACKAGES_UPGRADE_SCRIPT="/tmp/${USER}_packages_python_upgrade.sh"
PYTHON_PACKAGES_UPGRADE_LOG="/tmp/${USER}_python_packages_upgrade.log"

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
if [ ! -f "$PYTHON_PACKAGES_UPDATED" ] && [ ! -f "$PYTHON_PACKAGES_UPGRADE_SCRIPT" ];
then

cat <<EOF > "$PYTHON_PACKAGES_UPGRADE_SCRIPT"
    set -x
    # Delete all pip cached files
    pip cache purge

    # Usually multiple python versions exits:
    # - OSX default python: 3.x
    # - Homebrew default pythons: 3.x
    # -- Details: https://docs.brew.sh/Homebrew-and-Python

    # Global packages locations
    python3 -m site
    # Current user's packages locations
    python3 -m site --user-site

    # For homebrew python installations. See details at https://docs.brew.sh/Homebrew-and-Python

    # Install tool to easily upgrade python packages
    pip3 install pip_upgrade_outdated
    # Upgrade python packages, meeting other packages depedencies
    pip_upgrade_outdated -3 -s  # Python 3 support

    touch "$PYTHON_PACKAGES_UPDATED"
    chmod 777 "$PYTHON_PACKAGES_UPDATED"
    rm -f "$PYTHON_PACKAGES_UPGRADE_SCRIPT"

    set +x
EOF

rm -f "$PYTHON_PACKAGES_UPGRADE_LOG" > /dev/null 2>&1

( bash "$PYTHON_PACKAGES_UPGRADE_SCRIPT" > "$PYTHON_PACKAGES_UPGRADE_LOG" 2>&1 & )

fi

