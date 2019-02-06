# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi

# List all files colorized in long format, including dot files
alias l="ls -laHF ${colorflag}"
# List only directories
alias lsd="ls -lHF ${colorflag} | grep --color=never '^d'"
# List files colorized
alias ls="command ls ${colorflag}"
