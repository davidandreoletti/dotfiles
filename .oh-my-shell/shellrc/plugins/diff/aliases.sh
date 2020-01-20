# Diff, files side by side, using as much of the terminal view as possible. text will be wrapped if larger than the diff's window
function f_diff {
    local f1="$1"
    local f2="$2"
    local TERMINAL_VIEW_WIDTH=$(( $(tput cols) - 2 )); 
    local SIDE_VIEW_WIDTH=$(echo "scale=0 ; $TERMINAL_VIEW_WIDTH / 2" | bc);
    diff -y -W $TERMINAL_VIEW_WIDTH <( cat $f1 | fold -w $SIDE_VIEW_WIDTH ) <( cat $f2 | fold -w $SIDE_VIEW_WIDTH )
}

alias diff='f_diff '

