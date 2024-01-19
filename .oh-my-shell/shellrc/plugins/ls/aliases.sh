# Detect which `ls` flavor is in use
if ls --color >/dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi

listingflag="--all --human-readable -l --classify --time-style=long-iso --inode"

# Original ls with colorized output
alias ls="command ls --all --human-readable --classify ${colorflag}"
# List all files colorized in long format, including dot files, including file allocation and file max size
alias l="command ls ${listingflag} ${colorflag}"
# List only regural files
alias ls_file="command ls ${listingflag} ${colorflag} | grep --color=never '^\d\+ -.*$' "
# List only block special file
alias ls_block="command ls ${listingflag} ${colorflag} | grep --color=never '^\d\+ b.*$' "
# List only character special file
alias ls_char="command ls ${listingflag} ${colorflag} | grep --color=never '^\d\+ c.*$' "
# List only directories
alias ls_dir="command ls ${listingflag} ${colorflag} | grep --color=never '^\d\+ d.*$' "
# List only symbolic links
alias ls_symbolic="command ls ${listingflag} ${colorflag} | grep --color=never '^\d\+ l.*$' "
# List only fifo files
alias ls_fifo="command ls ${listingflag} ${colorflag} | grep --color=never '^\d\+ p.*$' "
