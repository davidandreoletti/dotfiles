# Tumx with better UX/TUI, creating session if not pre-selected one used
# usage: tmux
# usage: tmux session_name
alias dtmux='f_tmux_open_or_create_session cwd'

# Tumx with better UX/TUI, forcing selection of an existing session
# usage: ttmux
# usage: ttmux session_name
alias ttmux='f_tmux_open_or_create_session interactive'

# Start tmux with brand new server instance and no configuration file
# usage: tmux_none
alias tmux_none='command tmux -L test_$USER_$$ -f /dev/null'

# Clean + graceful kill all tmux session + server
# usage: tmux_kill_server
alias tmux_kill_server='command tmux kill-server '

# Start server
# usage: tmux_start_server
alias tmux_start_server='command tmux start-server '

# Show/hide news tmux session 
# usage: tmux_news on
# usage: tmux_news off
alias tmux_news='f_tmux_group_switcher news'

# Show/hide android tmux session
# usage: tmux_android on
# usage: tmux_android off
alias tmux_android='f_tmux_group_switcher android'
