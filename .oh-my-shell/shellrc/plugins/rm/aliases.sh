# Much safer rm
# usage: rm /path/to/dir
alias rm="rip --graveyard $RM_GRAVEYARD --inspect"

# Undo rm for last rm operatior or for a single file
# usage: rm_undo
# usage: rm_undo $RM_GRAVEYARD/file_deleted
alias rm_undo="rip --graveyard $RM_GRAVEYARD --unbury"

# List files sent to graveyard for the current directory
alias rm_stat="rip --graveyard $RM_GRAVEYARD --seance"

# Slightly safe rm
# usage: rm /path/to/file
alias rmi='command rm -i'

