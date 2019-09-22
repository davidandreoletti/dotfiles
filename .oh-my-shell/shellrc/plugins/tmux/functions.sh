# Utility Tmux
# Usage: tmux_has_window_with_name "session name" "window name"
# return 0 if yes. 1 otherwise
tmux_has_window_with_name() {
    local sessionName=$1 
    local windowName=$2
    tmux list-windows -t "$sessionName" | grep "$windowName" > /dev/null
}

# Usage: tmux_find_windowname_by_index "session name" "window name"
tmux_find_windowname_by_index() {
    local sessionName=$1
    local indexName=$2
    tmux list-windows -t "$sessionName" | grep "^$indexName:" | cut -f2 -d " "
}

# Usage: tmux_find_windowindex_by_windowname "session name" "index value"
tmux_find_windowindex_by_windowname() {
    local sessionName=$1
    local windowName=$2
    tmux list-windows -t "$sessionName" | grep ": $windowName" | cut -f1 -d " " | cut -f1 -d ":"
}

# Find current tmux session name
# Usage: tmux_find_current_session_name
# Return: Tmux session name
tmux_find_current_session_name() {
    # src: http://unix.stackexchange.com/questions/111499/how-do-i-know-the-name-of-a-tmux-session
    local sessionName=$(tmux display-message -p '#S')
    echo "$sessionName"
}

# Attach to a tmux session
# Usage: tmux_attach_session "session name"
tmux_attach_session() {
    local sessionName="$1"
    tmux attach-session -t "$sessionName"
}

# Get or create session with name
# Usage: tmux_get_or_create_session "session name"
tmux_get_or_create_session() {
    local sessionName="$1"
    if [ ! -z "$TMUX" ]; then # refactor with tmux_is_in_tmux_environement
        # In Tmux session
        sessionName=$(tmux_find_current_session_name)
    else 
        # Not in Tmux session
        tmux start-server
        tmux new-session -d -n "shell" -s "$sessionName" "$SHELL" > /dev/null
    fi
    echo "$sessionName"
}

# Get or create session with name
# Usage: tmux_is_in_tmux_environement
# Return: 0 -> yes. 1 -> no
tmux_is_in_tmux_environement() {
    if [ ! -z "$TMUX" ]; then
        # In Tmux session
        true
    else 
        # Not in Tmux session
        false
    fi
}

# Open window with windowindowName and running command
# Usage: tmux_open_window "mail" "mutt; bash" "session anme"
tmux_open_window() {
    local windowName="$1"
    local cmd="$2"
    #local sessionName=$(tmux_get_or_create_session "default")
    local sessionName="$3"
    # Create Tmux window
    tmux_has_window_with_name "$sessionName" "$windowName" || tmux new-window -t "$sessionName" -n "$windowName" "$cmd" 

    # http://stackoverflow.com/questions/5311583/tmux-how-to-make-new-window-stay-when-start-shell-command-quits
    # Keep bash running once initial command finished
    # src: http://unix.stackexchange.com/questions/17116/prevent-pane-window-from-closing-when-command-completes-tmux
}

# Closes a window by windowName
# Usage: tmux_close_window "mail"  "session name"
tmux_close_window() {
    local windowName="$1"
    local sessionName=$2

    tmux_is_in_tmux_environement || return
    tmux_has_window_with_name "$sessionName" "$windowName" && tmux kill-window -t "$sessionName:$windowName"
}

# Show window with windowName
# Usage: tmux_open_window "session name" "window name"
tmux_show_window() {
    local sessionName=$1
    local windowName=$2

    tmux_is_in_tmux_environement || tmux_attach_session "$sessionName"

    tmux select-window -t "$sessionName:$windowName"
}

tmux_news_show() {
    set -x
    local sessionName=$(tmux_get_or_create_session "news")
    tmux_open_window "mail" 'until mutt && false; do sleep 1; done; bash' "$sessionName"
    tmux_open_window "rss" 'until newsbeuter && false; do sleep 1; done; bash' "$sessionName"
    tmux_open_window "irc" 'until irssi && false; do sleep 1; done; bash' "$sessionName"
    # Show mail window by default in the current session
    tmux_show_window "$sessionName" "mail"
    set +x
}

tmux_news_hide() {
    local sessionName=$(tmux_find_current_session_name)
    tmux_close_window "mail" "$sessionName"
    tmux_close_window "rss" "$sessionName"
    tmux_close_window "irc" "$sessionName"
}

tmux_android_show() {
    set -x
    local sessionName=$(tmux_get_or_create_session "android")
    tmux_open_window "adblog" 'until adb logcat && false; do sleep 1; adb logcat -c; done; bash' "$sessionName"
    set +x
}

tmux_android_hide() {
    local sessionName=$(tmux_find_current_session_name)
    tmux_close_window "adblog" "$sessionName"
    tmux_show_window "$sessionName" "adblog"
}

tmux_session_get_or_create() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then 
     tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}



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
#       - interactive: Session named after interactively selecting one session
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
