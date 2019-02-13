# Usage: mpd_loader.sh file.m3u file2.m3u ...

for f in $*
do
    if [ -f $f ] && [ -r $f ]
    then
        all=$(echo "$(command cat $f | sort)")
        youtube=$(echo -e "$all" | command grep "youtube.com")
        remaining=$(command comm -23 <(echo -e "$all") <(echo -e "$youtube"))

        # "remaining" urls can be used as is
        remainingFd=<(echo -e "$remaining") \
        # "youtube" urls must be contverted first
        youtubeFd=<(echo -e "$youtube" | xargs youtube-dl -f 'worst' -g )

        # Print to stdout url to be loaded by mpc add or similar client
        command cat $remainingFd $youtubeFd 
    fi
done
