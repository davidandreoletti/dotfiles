###############################################################################
# Todolist related functions
###############################################################################

TODOLIST_FILE="${BOOSTRAP_DIR}/TODO-bootstrap-machine.txt"

todolist_show_read_todolist() {
    message_warning_show "Some things MUST be setup up at manually. Read $TODOLIST_FILE for details or alternatively look hereafter"
    cat "$TODOLIST_FILE"
}

#param1: append text in todo list
_todolist_append() {
    if [[ -e "$TODOLIST_FILE" ]]
    then
         echo "$1" >> "$TODOLIST_FILE"
    else
        echo "$1" > "$TODOLIST_FILE" #FIXME No such file or dir`
    fi
}

# param1: entry name
# param2: entry details
todolist_add_new_entry() {
    _todolist_append "* TODO $1"
    _todolist_append "** $2"
    _todolist_append "** $3"
}
