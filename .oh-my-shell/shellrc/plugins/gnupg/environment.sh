# gpg 2.1.0+ requires GPG_TTY to
#  - hide "Inappropriate ioctl for device" messages
GPG_TTY=$(tty)
export GPG_TTY
