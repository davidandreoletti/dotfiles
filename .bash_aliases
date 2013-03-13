# Shell aliases
alias mv='mv -v'
alias rm='rm -i'

# ls command aliases
# dumb terminal ? http://en.wikipedia.org/wiki/Computer_terminal
if [ "$TERM" != "dumb" ]; then
    if [ `uname` == "Darwin" ]; then
       alias ls='ls -G'
    else
       eval "`dircolors -b`"
       alias ls='ls --color=auto'
    fi
fi
alias ll='ls -alh'

# http://serverfault.com/a/28649
up(){
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}
alias cd..='up'

# Compression aliases
alias xt='unp'

# Git alias
alias gitlg='git log --graph --all --format=format:'"'"'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n'"'"''"'"'          %C(white)%s%C(reset) %C(bold white)— %an%C(reset)'"'"' --abbrev-commit'
alias gitdif='git diff'
alias gitps='git push'
alias gitpl='git pull'
alias gitst='git status'

# Mercurial alias
alias hgsm='hg summary'
alias hgl='hg log -G --template "{rev}:{node}:{branch}\n{author}\n{desc|firstline}\n\n" | more'

# Bash Usages
function check_()
{
cut -f1 -d" " $1 | sort | uniq -c | sort -nr | head -n 30
}
alias mybashusage='check_ ~/.bash_history'
