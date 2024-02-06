if is_macos; then
    RM_GRAVEYARD="$HOME/.Trash"
elif is_linux; then
    RM_GRAVEYARD="$XDG_DATA_HOME/Trash"
fi

! test -d "$dir" && mkdir -p "$RM_GRAVEYARD"
