function f_shellrc_plugin_create() {
    local name="$1"
    local main="$SHELLRC_OH_MY_SHELLRC"
    local plugin_dir="$SHELLRC_PLUGINS_DIR_LOCAL/$name"

    f_shellrc_plugin_edit "$name" 1

    echo "plugin: $name :register"
    $EDITOR "$main"

    f_shellrc_plugin_reload "$name"
}

function f_shellrc_plugin_edit() {
    local name="$1"
    local reload_plugin="${2:-0}"
    local main="$SHELLRC_OH_MY_SHELLRC"
    local plugin_dir="$SHELLRC_PLUGINS_DIR_LOCAL/$name"

    echo "plugin: $name :create structure"
    mkdir -p "$plugin_dir"
    command touch "$plugin_dir/aliases.sh"
    command touch "$plugin_dir/functions.sh"
    command touch "$plugin_dir/environment.sh"
    command touch "$plugin_dir/post.sh"

    echo "plugin: $name :edit function"
    $EDITOR $plugin_dir/*.sh

    . "$DOTFILES_HOME_LOCAL/install/common/shell/stow.sh"

    stow_files "$USER" "$DOTFILES_HOME_LOCAL" "$HOME"

    # Reload shell
    [ $reload_plugin ] && f_shellrc_plugin_reload "$name"
}

function f_shellrc_plugin_reload() {
    local name="$1"
    local main="$SHELLRC_OH_MY_SHELLRC"
    local plugin_dir="$SHELLRC_PLUGINS_DIR_LOCAL/$name"

    echo "plugin: $name :reloading"

    dot_plugin_if_exists "$name"
}

