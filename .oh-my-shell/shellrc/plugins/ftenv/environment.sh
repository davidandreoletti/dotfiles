# https://github.com/tfutils/tfenv#tfenv_debug
export TFENV_DEBUG=1

# Location of config file
export TFENV_CONFIG_DIR="$HOME/.tfenv"
mkdir -p "$TFENV_CONFIG_DIR"

# Location of locally installed terraform versionss
export TFENV_INSTALL_DIR="$TFENV_CONFIG_DIR/versions"
mkdir -p "$TFENV_INSTALL_DIR"
