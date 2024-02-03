# gpg 2.1.0+ requires GPG_TTY to
#  - hide "Inappropriate ioctl for device" messages

if is_zsh;
then
    # https://gist.github.com/mcattarinussi/834fc4b641ff4572018d0c665e5a94d3?permalink_comment_id=4382229#gistcomment-4382229
    GPG_TTY="${TTY:-"$(tty)"}"
else
    GPG_TTY=$(tty)
fi
export GPG_TTY
