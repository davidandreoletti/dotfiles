PYTHON_POST_BASE="/tmp/${USER}_python_post"
PYTHON_POST_MARKER="${PYTHON_POST_BASE}.marker"

# 3600*24*15 = 30 days
if f_run_every_x_seconds "$PYTHON_POST_MARKER" "$((3600*24*30))" ;
then

    # Always install the latest python version per MAJOR.MINOR group
    PYTHON_INSTALL_SCRIPT="${PYTHON_POST_BASE}.install.sh"
    PYTHON_INSTALL_LOG="${PYTHON_INSTALL_SCRIPT}.log"

cat <<EOF > "$PYTHON_INSTALL_SCRIPT"
    for v in 3.11 3.10 3.9; 
    do 
        echo "Installing \$v"
        pyenv install --skip-existing "\$v"  # "\$v:latest"
    done 
EOF

    f_run_exclusive_in_background_with_completion "${PYTHON_INSTALL_SCRIPT}.lockfile" "$PYTHON_INSTALL_LOG" "$PYTHON_POST_MARKER" bash $PYTHON_INSTALL_SCRIPT

    # Force packages upgrades every 15d
    PYTHON_PACKAGES_UPGRADE_SCRIPT="${PYTHON_POST_BASE}.package_upgrades.sh"
    PYTHON_PACKAGES_UPGRADE_LOG="${PYTHON_PACKAGES_UPGRADE_SCRIPT}.log"

cat <<EOF > "$PYTHON_PACKAGES_UPGRADE_SCRIPT"
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
EOF

    f_run_exclusive_in_background_with_completion "${PYTHON_PACKAGES_UPGRADE_SCRIPT}.lockfile" "$PYTHON_PACKAGES_UPGRADE_LOG" "$PYTHON_POST_MARKER" bash $PYTHON_PACKAGES_UPGRADE_SCRIPT
fi
