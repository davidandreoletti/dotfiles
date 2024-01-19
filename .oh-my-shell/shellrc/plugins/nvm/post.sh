# Use default nvm managed node version

function nvmInstallDefaultNode() {
    nvm install --lts &>/dev/null
    nvm alias default node &>/dev/null
}

function nvmSetDefaultNode() {
    nvm use --delete-prefix default --silent
}

USER_NVM_DIR_PATH="$HOME/.nvm"
NVM_PLUGIN_DEFAULT_NODE_INSTALLED="$USER_NVM_DIR_PATH/default.node.installed"

[ ! -f "$NVM_PLUGIN_DEFAULT_NODE_INSTALLED" ] && nvmInstallDefaultNode && mkdir -p "$USER_NVM_DIR_PATH" && touch "$NVM_PLUGIN_DEFAULT_NODE_INSTALLED"
# Slow loading
[ -f "$NVM_PLUGIN_DEFAULT_NODE_INSTALLED" ] && nvmSetDefaultNode
