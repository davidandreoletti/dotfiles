# Shell history
# - History file location
HISTFILE=$HOME/.bash_history_permanent
# - Append command to history
shopt -s histappend
# - Max entries in history in RAM
HISTSIZE=9000000
# - Max entries in history on disk
HISTFILESIZE=$HISTSIZE
# History record timestamp per command
HISTTIMEFORMAT='%s'
# Filter out of the history
HISTIGNORE="&:[bf]g:c:clear:history:exit:q:pwd:* --help"

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history.
export PROMPT_COMMAND='history -a'
HISTCONTROL=ignoreboth:erasedups

# Multiline command saved as single history entry
shopt -s cmdhist
