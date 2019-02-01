f_tmux_get_session_named_after_current_directory() {
    local path="$(pwd)"
    local name=$(basename $path)
    # Remove all characters not allowed as session name by tmux 
    name=$(echo $name | tr -d .)
    echo $name
}

# Open/switch existing session or create tmux session
# Usage: f_tmux_open_or_create_session BEHAVIOUR OPTIONAL_SESSION_NAME 
# - BEHAVIOUR : choose OR dirname (default)
# - OPTIONAL_SESSION_NAME : someName
# modified src: https://github.com/junegunn/fzf/wiki/examples#tmux
f_tmux_open_or_create_session () {
    # Open exiting session:
    # - manually when 2+ session partially match the session name
    # - automatically when 1 session partially match the session name
    # Create new session:
    # - automatically when 0 session partially match the session name
    local behaviour=${1:-"dirname"}

    if [ "$behaviour" == "dirname" ];
    then
        local defaultSessionName=$(f_tmux_get_session_named_after_current_directory)
        local prefered=${2:-$defaultSessionName}
    fi

    if [ "$behaviour" == "select" ];
    then
        local prefered=${2:-"default"}
    fi

    local session=$(command tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --select-1 --query=$prefered || echo $prefered) 

    # Inside tmux, try switch current client's session to session. Otherwise fallback to (create) + attach to the session
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"

    tmux $change -t "$session" 2>/dev/null || (tmux new-session -d -s "$session"; tmux $change -t "$session"); 
}
