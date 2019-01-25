# Shell history
shopt -s histappend
export PROMPT_COMMAND='history -a'
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=$HISTSIZE
HISTTIMEFORMAT='%F %T%t'
HISTFILE=$HOME/.bash_history

# Load bash completions
# Note: List all completions routine with "complete -p"
[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
