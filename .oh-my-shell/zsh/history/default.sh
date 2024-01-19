# Shell history
setopt APPEND_HISTORY # zsh sessions will append their history list to the history file, rather than replace it.
# multiple parallel zsh sessions will all have the new entries from their history lists added to the history file, in the order that they exit.
setopt HIST_FIND_NO_DUPS  # When searching for history entries in the line editor, do not display duplicates of a line previously found, even if the duplicates are not contiguous.
setopt INC_APPEND_HISTORY # works like APPEND_HISTORY except that new history lines are added to the $HISTFILE incrementally (as soon as they are entered), rather than waiting until the shell exits.
setopt SHARE_HISTORY      # both imports new commands from the history file, and also causes your typed commands to be appended to the history file
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=$HOME/.zsh_history
