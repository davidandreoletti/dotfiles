# % search, directory, largest
# # Find largest directory, sorted by largest to smaller
# # https://serverfault.com/a/156648
# # regquires gnu coreutils
# ; search_largest_dirs_asc
alias search_largest_dirs_asc='du -hs * | sort -h'

# % search, code
# # Find PATTERN code fragment
# ; search_code_fragment
alias search_code_fragment='f_search_code_fragment '

# % search, any, doc
# # Find PATTERN in any kind of doc
# ; search_anything
alias search_anything='f_search_anything '

# FIXME: what to do with this ?
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
