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
export KEYTIMEOUT=1

# Search history as in Bash with Ctrl-R 
bindkey '^R' history-incremental-search-backward

