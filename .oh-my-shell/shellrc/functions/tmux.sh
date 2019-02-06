f_tmux_get_session_named_after_current_directory() {
    local path="$(pwd)"
    local name=$(basename $path)
    # Remove all characters not allowed as session name by tmux 
    name=$(echo $name | tr -d .)
    echo $name
}

# Open/switch existing session or create tmux session
# Usage: f_tmux_open_or_create_session BEHAVIOUR OPTIONAL_SESSION_NAME 
# - BEHAVIOUR : 
#       - interactive: Session named after interactively selection one
#       - cwd (default): Session named after current directory name, unless OPTIONAL_SESSION_NAME is specified
# - OPTIONAL_SESSION_NAME : someName
# modified src: https://github.com/junegunn/fzf/wiki/examples#tmux
f_tmux_open_or_create_session () {
    # Open exiting session:
    # - manually when 2+ session partially match the session name
    # - automatically when 1 session partially match the session name
    # Create new session:
    # - automatically when 0 session partially match the session name
    local behaviour=${1:-"cwd"}

    case $behaviour in
        cwd)
            local defaultSessionName=$(f_tmux_get_session_named_after_current_directory)
            local prefered=${2:-$defaultSessionName}
            ;;
        interactive)
            local prefered=${2:-"default"}
            ;;
        *)
            local prefered=${2:-"default"}
            ;;
    esac

    local session=$(command tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --select-1 --query=$prefered || echo $prefered) 

    # Inside tmux, try switch current client's session to session. Otherwise fallback to (create) + attach to the session
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"

    command tmux $change -t "$session" 2>/dev/null || (command tmux new-session -d -s "$session"; command tmux $change -t "$session"); 
}

# ftpane - switch pane (@george-b)
# src: https://github.com/junegunn/fzf/wiki/examples#tmux
f_tmux_pane_switcher() {
    local panes current_window current_pane target target_window target_pane
    panes=$(command tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
    current_pane=$(command tmux display-message -p '#I:#P')
    current_window=$(command tmux display-message -p '#I')

    target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

    target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
    target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

    if [[ $current_window -eq $target_window ]]; then
        command tmux select-pane -t ${target_window}.${target_pane}
    else
        command tmux select-pane -t ${target_window}.${target_pane} &&
            command tmux select-window -t $target_window
    fi
}

# ftsess - switch session (based on @george-b)
# modified src: https://github.com/pokey/dotfiles/blob/master/bin/ftsess
f_tmux_session_switcher() {
    sessions=$(command tmux list-sessions -F '#S')

    target=$(echo "$sessions" | fzf-tmux +m --reverse)
    res=$?
    [ "$res" -eq "130" ] && exit 0
    [ "$res" -eq "0" ] || exit $res

    command tmux switch-client -t "$target"
}

# ftwind - switch window (based on @george-b)
# modified: src https://github.com/pokey/dotfiles/blob/master/bin/ftwind
f_tmux_window_switcher() {
    windows=$(command tmux list-windows -F '#I - #(basename #{pane_current_path}) (#{window_name})')

    target=$(echo "$windows" | fzf-tmux +m --reverse)
    res=$?
    [ "$res" -eq "130" ] && exit 0
    [ "$res" -eq "0" ] || exit $res

    target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')

    command tmux select-window -t $target_window
}
