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
if [ -d "$HOME/bin" ] ; then
   export PATH="$HOME/bin:$PATH"
fi

# Add GNU coretutils (if installed) to have dircolors and prevent all
# coretutils tools (eg: dircolors) to be prefixed with g (eg: gdircolors)
# on OSX
# OSX: brew install coreutils
# FIXME: Check OS === OSX for OSX specific paths
OSX_HOMEBREW_GNUCOREUTILS_DIR="/usr/local/opt/coreutils/libexec"
if [ -d "$OSX_HOMEBREW_GNUCOREUTILS_DIR/gnubin" ] ; then
    export PATH="$OSX_HOMEBREW_GNUCOREUTILS_DIR/gnubin:$PATH"
fi

if [ -d "$OSX_HOMEBREW_GNUCOREUTILS_DIR/gnuman" ] ; then
    export MANPATH="$OSX_HOMEBREW_GNUCOREUTILS_DIR/gnuman:$MANPATH"
fi

# Load shell specific config
SHELLRC_ENVIRONMENT_SHELL_FILE="${SHELLRC_DIR}/${SHELL_NAME}/environment.sh"
[[ -s ${SHELLRC_ENVIRONMENT_SHELL_FILE} ]] && . "${SHELLRC_ENVIRONMENT_SHELL_FILE}"

