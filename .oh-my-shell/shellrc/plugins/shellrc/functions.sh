function f_shellrc_plugin_create() {
    local name="$1"
    local main="$HOME/.oh-my-shell/oh-my-shellrc"
    local plugin_dir="$SHELLRC_PLUGINS_DIR/$name"

    # Create plugin dir/file structure
    mkdir -p "$plugin_dir"
    command touch "$plugin_dir/aliases.sh"
    command touch "$plugin_dir/functions.sh"
    command touch "$plugin_dir/environment.sh"
    command touch "$plugin_dir/post.sh"

    echo "Add plugin '$name' to $main"
    # FIXME Use EDITOR - once 'vim' is aliased to nvim issue is fixed
    vim "$main"

    echo "Edit plugin '$name'"
    # FIXME Use EDITOR - once 'vim' is aliased to nvim issue is fixed
    vim $plugin_dir/*.sh

    # FIXME: Call stow to symlink the plugin into ~/.oh-my-shell

    # Reload shell
    shell_reload_profile
}
