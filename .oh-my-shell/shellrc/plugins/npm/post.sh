NPM_POST_BASE="$HOME/.oh-my-shell/tmp/npm_post"
NPM_POST_MARKER="${NPM_POST_BASE}.marker"

# 3600*24*30 = 30 days
if f_run_every_x_seconds "$NPM_POST_MARKER" "$((3600 * 24 * 30))"; then

    # Upgrade npm managed global pakcages
    NPM_PACKAGES_UPGRADE_SCRIPT="${NPM_POST_BASE}.npm_packages_upgrade.sh"
    NPM_PACKAGES_UPGRADE_LOG="${NPM_PACKAGES_UPGRADE_SCRIPT}.log"

    cat <<EOF >"$NPM_PACKAGES_UPGRADE_SCRIPT"
    # Load nvm
    . $(brew --prefix nvm)/nvm.sh
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
EOF

    f_run_exclusive_in_background_with_completion "${NPM_PACKAGES_UPGRADE_SCRIPT}.lockfile" "$NPM_PACKAGES_UPGRADE_LOG" "$NPM_POST_MARKER" bash $NPM_PACKAGES_UPGRADE_SCRIPT
fi
