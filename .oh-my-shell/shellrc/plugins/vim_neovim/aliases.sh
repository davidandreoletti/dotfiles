[ -x "$(command -v nvim)" ] && alias vim='nvim'

# Vim editor without plugins loaded
# Usage: vimb /path/to/file
alias vimn='vim -u NONE '

# Wipe neovim shada file
# src: https://neovim.io/doc/user/starting.html#shada
alias nvimWipeShadaFile="rm -fv $HOME/.local/state/nvim/shada/main.shada"
