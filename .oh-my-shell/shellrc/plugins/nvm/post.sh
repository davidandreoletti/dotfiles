# Use default nvm managed node version

function nvmInstallDefaultNode() {
    nvm install --lts &> /dev/null
    nvm alias default node &> /dev/null
}

function nvmSetDefaultNode() {
    nvm use --delete-prefix default --silent
}

NVM_PLUGIN_DEFAULT_NODE_INSTALLED="$HOME/.nvm/default.node.installed"

[ ! -f "$NVM_PLUGIN_DEFAULT_NODE_INSTALLED" ] && nvmInstallDefaultNode && "$NVM_PLUGIN_DEFAULT_NODE_INSTALLED"
# Slow loading
[ -f "$NVM_PLUGIN_DEFAULT_NODE_INSTALLED" ] && nvmSetDefaultNode

