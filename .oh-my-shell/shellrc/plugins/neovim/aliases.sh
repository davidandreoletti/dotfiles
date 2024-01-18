command_exists 'nvim' && alias vim='nvim'

# % vim, no config
# # Vim editor without plugins loaded
# ; usage: vim_none /path/to/file
alias vim_none='vim -u NONE '

# % nvim, wipe shara
# # Wipe neovim shada file
# # src: https://neovim.io/doc/user/starting.html#shada
# ; usage: nvim_wipe_shada_file
alias nvim_wipe_shada_file="command rm -fv $HOME/.local/state/nvim/shada/main.shada"
