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

# % shellrc, benchmark, bash
# # Benchmark shellrc on bash interactive shell
# ; usage: shellrc_benchmark_on_bash
# FIXME Investigate how to start bash interactive, load bash profile and then exit
#alias shellrc_benchmark_on_bash='hyperfine --warmup 0 --runs 1 --shell=none "bash -i -c exit"'

# % shellrc, benchmark, zsh
# # Benchmark shellrc on zsh interactive shell
# ; usage: shellrc_benchmark_on_zsh
alias shellrc_benchmark_on_zsh='hyperfine --warmup 0 --runs 1 --shell=none "zsh -i -c exit"'
