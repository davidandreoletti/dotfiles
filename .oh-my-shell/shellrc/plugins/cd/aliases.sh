alias up='f_cd_up_to_nth_dir'
alias cd..='f_cd_up_to_nth_dir'
## Show current directory stack
alias cds='dirs -v'
## Clear directory stack
alias cdsc='dirs -c'
## Use cd with pushd
alias cd='f_cd_pushd'
alias cd-='f_cd_pushd -'
## Use cd with popd
for i in {1..20}; do alias cd$i="_cd_popd $i"; done

