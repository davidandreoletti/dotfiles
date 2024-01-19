## http://serverfault.com/a/28649
function f_cd_up_to_nth_dir {
    local d=""
    limit=$1
    for ((i = 1; i <= limit; i++)); do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    builtin cd $d
}

## builtin cd equivalent using pushd/popd
# Behaviour:
# f_cd_pushd -   ==> same as builtin cd -
# f_cd_pushd foo ==> same as builtin cd foo
# f_cd_pushd     ==> same as builtin cd
# src: https://gist.github.com/mbadran/130469
function f_cd_pushd {
    if [ "$#" -gt "0" ]; then
        if [ "$1" = "-" ]; then
            pushd >/dev/null
        else
            pushd "$@" >/dev/null
        fi
    else
        pushd $HOME >/dev/null
    fi
}

function f_cd_popd {
    local number=0
    if [ "$#" -gt "0" ]; then
        number=$1
    fi

    local i=0
    number=$(($number - 1))
    while [ "$i" -lt "$number" ]; do
        popd >/dev/null
        i=$(($i + 1))
    done
}
