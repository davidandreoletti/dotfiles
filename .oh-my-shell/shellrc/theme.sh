#
# Cross shell theme/prompt config
#

SHELLRC_THEME_DIR="${SHELLRC_DIR}/themes"

# Current theme/prompt
SHELLRC_PROMPT_FILE="${SHELLRC_THEME_DIR}/myprompt.ps1"
[[ -s ${SHELLRC_PROMPT_FILE} ]] && . "${SHELLRC_PROMPT_FILE}"

# Load shell specific theme/prompt
SHELLRC_THEME_SHELL_FILE="${SHELLRC_DIR}/${SHELL_NAME}/shellrc/theme.sh"
[[ -s ${SHELLRC_THEME_SHELL_FILE} ]] && . "${SHELLRC_THEME_SHELL_FILE}"

