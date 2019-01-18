# Shell history
shopt -s histappend
export PROMPT_COMMAND='history -a'
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTTIMEFORMAT='%F %T%t'
HISTFILE=$HOME/.bash_history

