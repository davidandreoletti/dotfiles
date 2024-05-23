################################################################################
# Tmux Plugin manager
################################################################################

tmux_install_tpm() {
    TMUX_PLUGINS_DIR=".tmux/plugins/tpm"
    git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGINS_DIR" || git -C "$TMUX_PLUGINS_DIR" pull
}
