function f_pipesByProcessName () {
    local regex="$1"
    #sudo lsof -p $(sudo ps -a | grep "pv \|wc \|sha256sum \|dd \|tee \|cat \|ucat" | grep -v "grep" | cut -d' ' -f1 | tr -d "[:blank:]" | tr '\012' ',')
    sudo lsof -p $(sudo ps -a | grep "$regex" | grep -v "grep" | cut -d' ' -f1 | tr -d "[:blank:]" | tr '\012' ',')
}
