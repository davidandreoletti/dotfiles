[ -x "$(command -v nvim)" ] && alias vim='nvim'

# Vim editor without plugins loaded
# Usage: vimb /path/to/file
alias vim_none='vim -u NONE '

# Wipe neovim shada file
# src: https://neovim.io/doc/user/starting.html#shada
alias nvim_wipe_shada_file="rm -fv $HOME/.local/state/nvim/shada/main.shada"
