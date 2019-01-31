#
# Cross shell aliases definitions
#

# Shell aliases
alias mv='mv -v'
alias rm='rm -i'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi
# List all files colorized in long format, including dot files
alias ll="ls -laHF ${colorflag}"
# List only directories
alias lsd="ls -lHF ${colorflag} | grep --color=never '^d'"
# List files colorized
alias ls="command ls ${colorflag}"

# tree command alias
alias tree='tree -aC --dirsfirst "$@" | less -FRNX'

# Backup file/dir with simple "-xxx" suffix
duplicate_with_simple_numbering() {
    local relsrcfile=`echo "$1" | sed -e 's#/$##'`
    local abssrcfile=`pwd`"/$relsrcfile"
    local suffixdelimiter="-"

    # Find next free number
    local number=0;
    local suffix
    until [ ! -e "$relsrcfile$suffix" ];
    do
        numberformat=`printf "%03i" $number`
        suffix="$suffixdelimiter$numberformat"
        number=$((number + 1))
    done

    echo "$relsrcfile -> $relsrcfile$suffix"
    cp -rfp $relsrcfile{,$suffix}
}
alias backup="duplicate_with_simple_numbering"

# Mark directory to not be backup by rsync (for consumption by my own custom rsync backup script)
alias backup-ignore="echo \"- /*\" > .backup.ignore"

# cd aliases
## http://serverfault.com/a/28649
function _cd_up_to_nth_dir {
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
  command cd $d
}
alias up='_cd_up_to_nth_dir'
alias cd..='_cd_up_to_nth_dir'

## builtin cd equivalent using pushd/popd
# Behaviour:
# cd2 - ==> same as builtin cd -
# cd2 foo ==> same as builtin cd foo
# cd2 ==> same as builtin cd
# src: https://gist.github.com/mbadran/130469
function _cd_pushd {
    if (("$#" > 0)); then
        if [ "$1" == "-" ]; then
            pushd > /dev/null
        else
            pushd "$@" > /dev/null
        fi
    else
        cd $HOME
    fi
}

function _cd_popd {
    local number=0
    if (("$#" > 0)); then
       number=$1 
    fi

    local i=0
    number=$(($number - 1))
    while [ "$i" -lt "$number" ];
    do
        popd > /dev/null
        i=$(($i + 1))
    done
}

## Show current directory stack
alias cds='dirs -v'
## Clear directory stack
alias cdsc='dirs -c'
## Use cd with pushd
alias cd='_cd_pushd'
alias cd-='_cd_pushd -'
## Use cd with popd
for i in {1..20}; do alias cd$i="_cd_popd $i"; done

# Compression aliases
alias xt='unp'

# Git alias
alias gtlg='git lg'
alias gtdf='git diff'
alias gtps='git push'
alias gtpl='git pull'
alias gtst='git status'

# Mercurial alias
alias hgsm='hg summary'
alias hgst='hg status'
alias hglg='hg log -G --template "{rev}:{node}:{branch}\n{author}\n{desc|firstline}\n\n" | more'

alias telnet-big5='luit -encoding big5 telnet'

# Bash Usages
function check_()
{
cut -f1 -d" " $1 | sort | uniq -c | sort -nr | head -n 30
}
alias mybashusage='check_ ~/.bash_history'
alias myzshusage='check_ ~/.zsh_history'

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

# Get http headers
function http_headers() { /usr/bin/curl -I -L $@ ; }

# Swap two files together
function swapthem()
{
    local TMPFILE=tmp.$$
    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

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

# Get week number
alias week='date +%V'

# Maven
alias mvnjavadoc='mvn javadoc:javadoc'

# Android
#
alias adbclog='adb logcat -c && adb logcat'

f_noobfuscatedstacktraceandroid() {
    '$ANDROID_HOME/tools/proguard/bin/retrace.sh -verbose "$1" "$2"'
}

# Print unbofuscated stacktrace
# Usage: androidShowPlaintextStacktrace "proguard_mapping.txt" "obfucated_stacktrace.txt"
alias androidShowPlaintextStacktrace='f_noobfuscatedstacktraceandroid $1 $2'

# List AndroidManifest.xml file data
# Usage: showAndroidManifest some.apk
alias showAndroidManifest='aapt l -a '

# Reset android logs and terminal
alias resetAndroidDebuTerminal="clear; tmux clear-history; adb logcat -c; adb logcat"

# Take screenshot of Android device screen
# src: http://blog.shvetsov.com/2013/02/grab-android-screenshot-to-computer-via.html
# usage: androidTakeScreenshot screenshot.png
alias androidTakeScreenshot="adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $1"

# Take video of Android device screen
# usage: androidTakeVideo video.mp4
function androidTakeVideoImpl() { 
    echo "Ctrl+C to stop recording."
    adb shell rm /sdcard/$1;
    adb shell -x screenrecord --bit-rate 10000000 /sdcard/$1;
    echo "Saving file to `pwd`/$1."
    sleep 2s; # Wait for file to be saved fully on device
    adb pull /sdcard/$1;
} 
alias androidTakeVideo="androidTakeVideoImpl $1"

# Xcode
# http://stackoverflow.com/a/18933476/219728
alias xcodePurgeDerivedData='rm -rf ~/library/Developer/Xcode/DerivedData/*'

# SSH
#
alias ssh_key_generate_rsa_4096='ssh-keygen -t rsa -b 4096'
alias ssh_key_protect='chmod 700'
#Typically you want the .ssh directory permissions to be 700 (drwx------) and the public key (.pub file) to be 644 (-rw-r--r--). Your private key (id_rsa) should be 600 (-rw-------).
# usage: ssh_is_private_key_password_correct and let yourself be guided by the command execution
alias ssh_is_private_key_password_correct='echo "Type ssh key full path" && read path && ssh-keygen -y -f "$path" && echo "Passowrd is correct for $path" || echo "Password incorrect for $path"'
# Usage: ssh_show_key_hashes "absolute path to ssh key private or public, but generally public"
alias ssh_show_key_hashes='echo "Type ssh key full path" && read path && ssh-keygen -E md5 -lf "$path" && ssh-keygen -E sha256 -lf "$path"'
# Read Public key from PEM file (for example to output the public key into an ~/.ssh/authorized_keys file)
# Usage: ssh_extract_from_pem_public_key_only_as_rsa_format "/path/to/some/file.pem"
alias ssh_extract_from_pem_public_key_only_as_rsa_format='ssh-keygen -y -f '

# Backups
# for duplicity based backups
alias backupignoredir="touch .backup.ignore"

# Replay last command with sudo
# src: https://twitter.com/liamosaur/status/506975850596536320
alias fuck='sudo $(history -p \!\!)' 

alias printShellVariables='(set -o posix; set)'

# Update already installed non cask and cask brew packages
alias brew-upgrades="brew update; brew cleanup -s; brew upgrade; brew cask upgrade --greedy --force; brew prune; brew doctor; brew missing"

# Download web page (included CSS)
# Usage: downloadCompleteWebpage http://example.com/mypage.html
# Src: https://apple.stackexchange.com/questions/100570/getting-files-all-at-once-from-a-web-page-using-curl
alias downloadCompleteWebpage='wget -r -np -k ' 

#copyFolderStructureOnly {
#    find . -type d >dirs.txt
#    xargs mkdir -p <dirs.txt
#}
#
#copyFolderStructureOnlyV2 {
#    rsync -a --filter="-! */" source_dir/ target_dir/
#}

[ -x "$(command -v nvim)" ] && alias vim='nvim'

alias clr="clear; tmux clear-history;"

# Docker

f_dockerShowContainersInNetwork() {
    # https://stackoverflow.com/a/43904733
    docker network inspect $1 -f "{{json .Containers }}"
}

# Show containers in a specific network
#  Usage: dockerShowContainersInNetwork "my-container-name" where my-container-name is taken from docker ps's CONTAINER NAME column
alias dockerShowContainersInNetwork="f_dockerShowContainersInNetwork $1"

f_dockerSSHIntoContainer() {
	local containerName="$1"
	local dockerContainerID="`docker ps | grep \"$containerName\" | cut -d ' ' -f 1`"; 
	docker exec -it "$dockerContainerID" /bin/sh
}

# SSH into a running docker container
# Usage: dockerSSHIntoContainer "my-container-name", where my-container-name is taken from docker ps's CONTAINER NAME column
alias dockerSSHIntoContainer="f_dockerSSHIntoContainer "

# Usage: dockerPruneSpecificDanglingImagesLayer  <image_id>
alias dockerPruneSpecificDanglingImagesLayer="docker rmi "

# Usage: dockerPruneAllDanglingImagesLayers 
alias dockerPruneAllDanglingImagesLayers="docker rmi \$(docker images -f dangling=true -q)"

f_dockerRemoveContainerAndAssociatedVolumes() {
    local volumeRegex="$1"
    local volumeName=`docker volume ls -q | grep "$volumeRegex"`
    local containerId=`docker ps --filter volume="$volumeName" --format {{.ID}}`
    docker rm "$containerId" -f --volumes
}

# Usage: dockerRemoveContainerAndAssociatedVolumes "volume name"
alias dockerRemoveContainerAndAssociatedVolumes="f_dockerRemoveContainerAndAssociatedVolumes "

# Cat
alias cat="bat"

#
# Image Manipulation
# 

# Usage: concatImagesVertically in1.jpg in2.jpg in3.jpg out.jpg
alias concatImagesVertically="convert -append "

#
# HTTP Traffic
#
f_http_show_in_out_traffic() {
    local interfaces=${1:-"any"}
    local port=${2:-"80"}
    local verbs=${3:-"GET|POST|PUT|PATCH|DELETE"}
    echo "Listening to HTTP traffic from/to port $port on interface(s) $interfaces"

    sudo ngrep -d $interfaces -t "^($verbs)" "tcp and port $port"
}

# Show HTTP traffic on (default) all interfaces to/from port (default) 80 whose HTTP verbs are (default) GET|POST|PUT}PATCH|DELETE
# (ues ngrep)
# Usage: httpShowTraffic any 80 "GET|POST"
alias httpShowTraffic="f_http_show_in_out_traffic "

f_http_show_in_out_traffic2() {
    local interfaces=${1:-"all"}
    local port=${2:-"80"}
    local verbs=${3:-"GET|POST|PUT|PATCH|DELETE"}
    echo "Listening to HTTP traffic from/to port $port on interface(s) $interfaces"

    sudo tcpdump -i "$interfaces" -n -s 0  -w - "tcp port $port" | grep -a -o -E \"Host\: .*|$verbs \/.*\"
}

# Show HTTP traffic on (default) all interfaces to/from port (default) 80 whose HTTP verbs are (default) GET|POST|PUT}PATCH|DELETE
# (ues tcpdump)
# Usage: httpShowTraffic2 any 80 "GET|POST"
alias httpShowTraffic2="f_http_show_in_out_traffic2 "

# Diff
alias diff="diff --side-by-side"

#
# ZIP
#

# Usage: zipPasswordProtectedArchiveCreate "some.zip" "some.txt"
alias zipPasswordProtectedArchiveCreate='zip --encrypt '

#
# TMUX
#

f_tmux_create_or_attach_to_session_named_after_current_directory() {
    local path="$(pwd)"
    local name="$(basename $path)"
    # Remove any dot char
    name="$(echo \"$name\" | tr -d .)"
    tmux new-session -s "$name" -A
}
alias tmux=f_tmux_create_or_attach_to_session_named_after_current_directory

# Load shell specific aliases
SHELLRC_ALIAS_SHELL_FILE="${SHELLRC_CURRENT_SHELL_DIR}/aliases.sh"
[ -r ${SHELLRC_ALIAS_SHELL_FILE} ] && . "${SHELLRC_ALIAS_SHELL_FILE}"
