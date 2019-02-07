#
# Legacy aliases, awaiting to be moved to app specific aliases files
#

# Indicate what application is binded to port $1
alias whoisbindedonport='lsof -i :$1'

# pbcopy/pbpaste: Take standard input and place it in the system clipboard
# (to paste into other applications)
# src: http://jetpackweb.com/blog/2009/09/23/pbcopy-in-ubuntu-command-line-clipboard/
os_type_name=`get_os_type`
if [[ "$os_type_name" == "linux" ]]; then
    xclippresent=`command -v xclip >/dev/null 2>&1; echo $?`
    xselpresent=`command -v xsel >/dev/null 2>&1; echo $?`
    if [[ ${xclippresent} == 0 ]]; then
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
    elif [[ ${xselpresent} == 0 ]]; then
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
    fi
    unset xclippresent
    unset xselpresent
fi
unset os_type_name


#copyFolderStructureOnly {
#    find . -type d >dirs.txt
#    xargs mkdir -p <dirs.txt
#}
#
#copyFolderStructureOnlyV2 {
#    rsync -a --filter="-! */" source_dir/ target_dir/
#}

