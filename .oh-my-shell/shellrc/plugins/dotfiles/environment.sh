export DOTFILES_HOME=$(realpath "$(dirname $(readlink -f ~/.oh-my-shell/oh-my-shellrc))/../")
export DOTFILES_PRIVATE_HOME="$(dirname $(readlink -f $HOME/.ssh))"
