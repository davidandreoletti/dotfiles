# Find an alias very quickly
# usage: s
# usage: s 'alias_prefix_name'
alias s="alias | cut -d'=' -f1 | fzf --cycle --no-multi"
