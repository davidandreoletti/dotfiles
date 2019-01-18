#
# Cross shell theme/prompt loading
#

SHELLRC_THEME_DIR="${SHELLRC_DIR}/themes"

# Current theme/prompt
SHELLRC_THEME_FILE="${SHELLRC_THEME_DIR}/myprompt.ps1"
[[ -s ${SHELLRC_THEME_FILE} ]] && source "${SHELLRC_THEME_FILE}"

# Load shell specific theme/prompt
SHELLRC_STAGE1_SHELL_FILE="${SHELLRC_DIR}/${SHELL_NAME}/shellrc/stage1.sh"
[[ -s ${SHELLRC_STAGE1_SHELL_FILE} ]] && source "${SHELLRC_STAGE1_SHELL_FILE}"

