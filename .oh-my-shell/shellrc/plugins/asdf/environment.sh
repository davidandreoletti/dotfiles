# Load asdf
#. $(homebrew_package_path_prefix "/asdf/libexec/asdf.sh")

# Load plugins
#_asdf_plugin_installed="$(asdf plugin list)"
#echo "$_asdf_plugin_installed" | grep -q golang || asdf plugin add golang https://github.com/kennyp/asdf-golang.git
# NOT WORKING: echo "$_asdf_plugin_installed" | grep -q maven || asdf plugin add maven
#echo "$_asdf_plugin_installed" | grep -q java ||sdf plugin add java

# Set JAVA_HOME
# src: https://github.com/halcyon/asdf-java#java_home
#. ~/.asdf/plugins/java/set-java-home.bash
#. ~/.asdf/plugins/java/set-java-home.zsh
