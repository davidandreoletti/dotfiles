export DOTFILES_HOME=$(readlink -f "$HOME/.oh-my-shell/../")
export DOTFILES_PRIVATE_HOME="$(dirname $(readlink -f $HOME/.is-encrypted))"
