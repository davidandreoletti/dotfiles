#
#  Prompt theme: myprompt
#  Author: David Andreoletti - http://davidandreoletti.com
#  Description: Bash/Zsh compatible prompt
#

# Check for recent enough version of bash.
if test -n "$BASH_VERSION" -a -n "$PS1" -a -n "$TERM" ; then
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    if [[ $bmajor -lt 3 ]] || [[ $bmajor -eq 3 && $bminor -lt 2 ]]; then
        unset bash bmajor bminor
        return
    fi
    unset bash bmajor bminor

    _PR_SHELL_bash=true
    _PR_SHELL_zsh=false
    _PR_OPEN_ESC="\["
    _PR_CLOSE_ESC="\]"
    _PR_USER_SYMBOL="\u"
    _PR_HOST_SYMBOL='\h'
    _PR_TIME_SYMBOL="\t"
    _PR_PWD_SYMBOL='\w'
    _PR_NLC_SYMBOL='\n'    # New line character
elif test -n "$ZSH_VERSION" ; then
    setopt PROMPT_SUBST  # Required for the prompt string to be first subjected to parameter expansion, command substitution and arithmetic expansion.
    _PR_SHELL_bash=false
    _PR_SHELL_zsh=true
    _PR_OPEN_ESC="%{"
    _PR_CLOSE_ESC="%}"
    _PR_USER_SYMBOL="%n"
    _PR_HOST_SYMBOL="%m"
    _PR_TIME_SYMBOL="%*"
    _PR_PWD_SYMBOL="%~"
    _PR_NLC_SYMBOL='\n'
else
    echo "prompt: shell not supported" >&2
    return
fi


line () {
    local c=${1:-'-'}
    local n=${2:-`tput cols`}
    local span=`printf '%*s\n' "$n" '' | tr ' ' ${c}`
    echo $span
}

prompt_git() {
    git branch &>/dev/null || return 1
    HEAD="$(git symbolic-ref HEAD 2>/dev/null)"
    BRANCH="${HEAD##*/}"
    REVISION="$(git rev-parse --short HEAD 2> /dev/null)"
    REVISION_MSG=`git show -s --format=%s $REVISION 2> /dev/null | tr "\\n" " "`
    [[ -n "$(git status 2>/dev/null | \
        grep -F 'clean')" ]] && STATUS="" || STATUS="+"
    printf 'git:%s' "${BRANCH:-unknown}@${REVISION}${STATUS} <${REVISION_MSG}>"
}
prompt_hg() {
    hg branch &>/dev/null || return 1
    BRANCH="$(hg branch 2>/dev/null)"
    [[ -n "$(hg status 2>/dev/null)" ]] && STATUS="+" || STATUS=""
    REVISION="$(hg id --id)"
    REVISION=${REVISION/+/}
    REVISION_MSG=`hg log -r $REVISION --template '{desc}' | tr "\\n" " "`
    printf 'hg:%s' "${BRANCH:-unknown}@${REVISION}${STATUS} <${REVISION_MSG}>"
}
prompt_svn() {
    svn info &>/dev/null || return 1
    URL="$(svn info 2>/dev/null | \
        awk -F': ' '$1 == "URL" {print $2}')"
    ROOT="$(svn info 2>/dev/null | \
        awk -F': ' '$1 == "Repository Root" {print $2}')"
    BRANCH=${URL/$ROOT}
    BRANCH=${BRANCH#/}
    BRANCH=${BRANCH#branches/}
    BRANCH=${BRANCH%%/*}
    [[ -n "$(svn status 2>/dev/null)" ]] && STATUS="+"
    printf 'svn:%s' "${BRANCH:-unknown} ${STATUS}"
}
prompt_vcs() {
    prompt_git || prompt_hg || prompt_svn
}
# $1: Max string length to be returned. Default to number of columns in terminal
prompt_vcs_truncated () {
    local maxL=${1-`tput cols`}
    local str="$(prompt_vcs)"
    local strd="...>"
    local strdL=${#strd}
    local strL=${#str}
    [[ $strL -gt $maxL ]] && strL=$(($maxL-$strdL)) && str=${str:0:$strL}$strd
    echo $str 
}
prompt_date () {
    echo `date +"%Y/%m/%d@%-k:%M:%S"`
}
prompt_user () {
    echo $USER
}
prompt_hostname () {
    echo $_PR_HOST_SYMBOL 
}
prompt_term_width () {
    echo `tput cols`
}
prompt_line1() {
    echo '$(printf "%*s\r%s@%s%s" "$(prompt_term_width)" "$(prompt_vcs_truncated 100)" "[$(prompt_user)" "'$(prompt_hostname)']" "[$(prompt_date)]" )'
}
prompt_line2 () {
    echo $_PR_PWD_SYMBOL 
}
prompt_line3() {
    local v=""
    if [[ $EUID -eq 0 ]]; then
        v="#"
    else
        v="\$"
    fi
    echo $v
}
prompt_line0 () {
    echo '$(printf "%s" "$(line '_')")'
}

prompt_on() {
    local p=''
    p=$p$(prompt_line0)
    p=$p$'\n'"$(prompt_line1)" 
    p=$p$'\n'"[$(prompt_line2)]"
    p=$p$'\n'"$(prompt_line3)"

    if $_PR_SHELL_bash; then
        PS1="${p}"
    else # zsh
        PROMPT="${p}"
    fi
}
prompt_off() {
    PS1='\$'
}
prompt_on


