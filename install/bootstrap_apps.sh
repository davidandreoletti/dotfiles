source "${BOOSTRAP_DIR}/bootstrap_apps_cli.sh"

if test "$BOOTSTRAP_SKIP_APPS_GUI_INSTALL" = "0"; then
   message_info_show "Skip GUI apps installion"
else
    source "${BOOSTRAP_DIR}/bootstrap_apps_gui.sh"
fi

if test "$BOOTSTRAP_SKIP_APPS_DESKTOP_ENVIRONMENT_INSTALL" = "0"; then
   message_info_show "Skip Desktop Environment installation"
else
    source "${BOOSTRAP_DIR}/bootstrap_apps_desktop_environment.sh"
fi

