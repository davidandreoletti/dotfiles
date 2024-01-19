#
# Cross shell environment config
#

# Set default editors
export EDITOR=$(command which --skip-alias --skip-functions nvim)
export VISUAL=$EDITOR

# TERM reports the terminal type. Best to leave the terminal implementation report it
# - Apple's Terminal: xterm-256color
# - Alacritty: xterm-256color
# - kitty: ?
#
# Set 256 capable color
# Reported with:  find /lib/terminfo /usr/share/terminfo -name "*256*"
# http://push.cx/2008/256-color-xterms-in-ubuntu
#export TERM=xterm-256color

# Set PATH so it includes user's private bin if it exists
[ -d "$HOME/.bin" ] && path_prepend "$HOME/.bin"

# Load shell specific config
dot_if_exists "${SHELLRC_CURRENT_SHELL_DIR}/environment.sh"
