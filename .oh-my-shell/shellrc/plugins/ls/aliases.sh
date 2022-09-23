# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; 
then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi

# List all files colorized in long format, including dot files, including file allocation and file max size
alias l="command ls -slahF ${colorflag} --time-style=long-iso "
# List only directories
alias lsd="command ls -lhF ${colorflag} --time-style=long-iso | grep --color=never '^d' "

