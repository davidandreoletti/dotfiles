#
# Cross shell theme/prompt config
#

SHELLRC_THEME_DIR="${SHELLRC_ROOT_DIR}/themes"

# Current theme/prompt
SHELLRC_PROMPT_FILE="${SHELLRC_THEME_DIR}/myprompt.ps1"
[ -r ${SHELLRC_PROMPT_FILE} ] && . "${SHELLRC_PROMPT_FILE}"

# Load shell specific theme/prompt
SHELLRC_THEME_SHELL_FILE="${SHELLRC_CURRENT_SHELL_DIR}/theme.sh"
[ -r ${SHELLRC_THEME_SHELL_FILE} ] && . "${SHELLRC_THEME_SHELL_FILE}"

