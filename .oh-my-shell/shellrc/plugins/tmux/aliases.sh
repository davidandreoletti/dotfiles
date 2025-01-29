# % tmux, session, default
# # Tumx with better UX/TUI, creating session if not pre-selected one used
# ; usage: tmux <session_name>
alias dtmux='f_tmux_open_or_create_session cwd'

# % tmux, session, default
# # Tumx with better UX/TUI, forcing selection of an existing session
# ; usage: ttmux <session_name>
alias ttmux='f_tmux_open_or_create_session interactive'

# % tmux, server
# # Start tmux with brand new server instance and no configuration file
# ; usage: tmux_none
alias tmux_none='command tmux -L test_$USER_$$ -f /dev/null'

# % tmux, server
# # Clean + graceful kill all tmux session + server
# ; usage: tmux_kill_server
alias tmux_kill_server='command tmux kill-server '

# % tmux, server
# # Start server
# ; usage: tmux_start_server
alias tmux_start_server='command tmux start-server '
