#
# Utitily Tmux
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
