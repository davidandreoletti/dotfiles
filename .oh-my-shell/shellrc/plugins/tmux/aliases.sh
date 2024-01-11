# Tumx with better UX/TUI, creating session if not pre-selected one used
# usage: tmux
# usage: tmux session_name
alias tmux='f_tmux_open_or_create_session cwd'

# Tumx with better UX/TUI, forcing selection of an existing session
# usage: ttmux
# usage: ttmux session_name
alias ttmux='f_tmux_open_or_create_session interactive'

# Start tmux with brand new server instance and no configuration file
# usage: tmux_none
alias tmux_none='tmux -L test_$USER_$$ -f /dev/null'
