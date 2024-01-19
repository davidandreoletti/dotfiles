#
# Bootstrap cross shells config
#

OS_TYPE=$(get_os_type)
SHELL_SESSION_ID=$$
SHELL_NAME=$(get_shell_type)
SHELLRC_CURRENT_SHELL_DIR="${SHELLRC_ROOT_DIR}/${SHELL_NAME}"

# Load shell specific bootstrap config
dot_if_exists "${SHELLRC_CURRENT_SHELL_DIR}/boostrap.sh"
