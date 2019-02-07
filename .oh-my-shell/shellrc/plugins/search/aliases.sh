
# ff:  to find a file under the current directory
ff () { find . -name "$@" ; }

# grepfind: to grep through files found by find, e.g. grepf pattern '*.c'
# note that 'grep -r pattern dir_name' is an alternative if want all files 
ffwithPattern_() { find . -type f -name "$2" -print0 | xargs -0 grep "$1" ; }
# I often can't recall what I named this alias, so make it work either way: 
alias ffp='ffwithPattern_'

# grepfind: grep the whole dir
alias ffpg='egrep -R $1'

## Finds directory sizes and lists them for the current directory
function dirsize_()
{
du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
egrep '^ *[0-9.]*M' /tmp/list
egrep '^ *[0-9.]*G' /tmp/list
rm /tmp/list
}
alias dirsize='dirsize_'

#function showLargestFilesHeldOpen() {
#    lsof \
#    | grep REG \
#    | grep -v "stat: No such file or directory" \
#    | grep -v "/Library/Application" \
#    | grep -v DEL \
#    | awk '{if ($NF=="(deleted)") {x=3;y=1} else {x=2;y=0}; {print $(NF-x) "  " $(NF-y) } }'  \
#    | sort -n -u -r \
#    | numfmt  --field=1 --to=iec
#}

