#
# Bootstrap cross shells config
#

# Import app specific functions
dot_if_exists "${SHELLRC_FUNCTIONS_DIR}/tmux.sh"

OS_NAME=`get_os_type`
SHELL_NAME=`get_shell_type`
SHELLRC_CURRENT_SHELL_DIR="${SHELLRC_ROOT_DIR}/${SHELL_NAME}"

# Load shell specific config
dot_if_exists "${SHELLRC_CURRENT_SHELL_DIR}/boostrap.sh" 
