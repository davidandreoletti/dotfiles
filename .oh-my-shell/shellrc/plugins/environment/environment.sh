#
# Cross shell environment config
#

# Set default editors
export EDITOR=`which vim`
export VISUAL=$EDITOR

# Set 256 capable color
# Reported with:  find /lib/terminfo /usr/share/terminfo -name "*256*"
# http://push.cx/2008/256-color-xterms-in-ubuntu
export TERM=xterm-256color

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X";

# Set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && path_prepend "$HOME/bin"

# Load shell specific config
dot_if_exists "${SHELLRC_CURRENT_SHELL_DIR}/environment.sh"

