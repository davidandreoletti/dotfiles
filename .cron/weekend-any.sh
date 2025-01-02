# Find dotfiles root dir
DOTFILES_DIR="$(dirname $(dirname $(realpath /home/davidandreoletti/.config/tmux)))"

# Upgrade vim/neovim pluggins
sh -x $DOTFILES_DIR/install/app/vim/upgrade.sh
sh -x $DOTFILES_DIR/install/app/neovim/upgrade.sh
