# Shell history
# - History file location
HISTFILE=$HOME/.zsh_history_permanent
# - Append command to history
setopt APPEND_HISTORY # zsh sessions will append their history list to the history file, rather than replace it.
# - Max entries in history in RAM
HISTSIZE=9000000
# - Max entries in history on disk
SAVEHIST=$HISTSIZE
# History record timestamp per command
setopt EXTENDED_HISTORY
# Filter out of the history
HISTORY_IGNORE="&|([bf]g|clear|history|exit|pwd|* --help)"
# Write the history file immediately
setopt INC_APPEND_HISTORY
# Do not display a line previously found.
setopt HIST_FIND_NO_DUPS
# both imports new commands from the history file, and also causes your typed commands to be appended to the history file
setopt SHARE_HISTORY
# Expire duplicate entries first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST
# Don't record an entry that was just recorded again.
setopt HIST_IGNORE_DUPS
# Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_ALL_DUPS
# Don't record an entry starting with a space.
setopt HIST_IGNORE_SPACE
# Don't write duplicate entries in the history file.
setopt HIST_SAVE_NO_DUPS
# Remove superfluous blanks before recording entry.
setopt HIST_REDUCE_BLANKS
