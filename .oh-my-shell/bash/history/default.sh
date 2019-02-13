# Shell history
shopt -s histappend

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history.
export PROMPT_COMMAND='history -a'
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTTIMEFORMAT='%F %T%t'
HISTFILE=$HOME/.bash_history

# Don't add certain commands to the history file.
export HISTIGNORE="&:[bf]g:c:clear:history:exit:q:pwd:* --help"

# Save all lines in a multiline command in the same history entry
shopt -s cmdhist
