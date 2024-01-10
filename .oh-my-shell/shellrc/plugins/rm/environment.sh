if [[ "$OS_NAME" == "macosx" ]];
then
    RM_GRAVEYARD="$HOME/.Trash"
elif [[ "$OS_NAME" == "linux" ]];
then
    RM_GRAVEYARD="$XDG_DATA_HOME/Trash"
else
    RM_GRAVEYARD="/tmp/Trash/$USER"
fi
