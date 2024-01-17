# % shellrc, plugin, list
# # List shellrc's plugins
# ; usage: shellrc_plugin_list
alias shellrc_plugin_list='l $SHELLRC_PLUGINS_DIR/ | fzf'

# % shellrc, plugin, edit
# # Edit shellrc plugin function 
# ; usage: shellrc_plugin_edit 'plugin_name'
alias shellrc_plugin_edit='f_shellrc_plugin_edit '

# % shellrc, plugin, edit
# # Create shellrc plugin structure + function
# ; usage: shellrc_plugin_create 'plugin_name'
alias shellrc_plugin_create='f_shellrc_plugin_create '
