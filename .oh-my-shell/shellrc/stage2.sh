#
# Post cross shell config
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
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Add GNU coretutils (if installed) to have dircolors and prevent all
# coretutils tools (eg: dircolors) to be prefixed with g (eg: gdircolors)
# on OSX
# OSX: brew install coreutils
if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ] ; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

if [ -d "/usr/local/opt/coreutils/libexec/gnuman" ] ; then
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

# Brew change default option
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# Load shell specific config
SHELLRC_STAGE2_SHELL_FILE="${SHELLRC_DIR}/${SHELL_NAME}/stage2.sh"
[[ -s ${SHELLRC_STAGE2_SHELL_FILE} ]] && . "${SHELLRC_STAGE2_SHELL_FILE}"

