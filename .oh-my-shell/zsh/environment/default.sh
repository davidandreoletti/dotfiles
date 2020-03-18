# Enable vi mode 
# http://usevim.com/2013/10/09/vim-zsh/
bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^e' edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# Latency to switch between vim modes
# in milliseconds
export KEYTIMEOUT=1

# Search history as in Bash with Ctrl-R 
#bindkey '^R' history-incremental-search-backward
# Show history with arrow up key
bindkey '^[[A' fzf-history-widget

# cd into string typed on the terminal if said string is a directory
setopt autocd 
