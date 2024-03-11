###############################################################################
# Config file
# Format:
# Key0=Value0
# Key1=Value1
###############################################################################

# FIXME dummy value + restore to UNKNOWN
platfrom="$(uname -a)"
case "$platform" in
    Darwin*)
        CONFIG_MACOSX_VNC_PASSWORD="dummy"
        CONFIG_MACOSX_USER_ADMIN_PASSWORD="dummy"
        CONFIG_MACOSX_TIMEMACHINE_USERNAME="davidandreoletti"
        CONFIG_MACOSX_TIMEMACHINE_PASSWORD="dummy"
        ;;
    Linux*)
        ;;
    *)
        echo "Unsupported platform: $platfrom"
        ;;
esac

is_config_key_set() {
    s=$1
    eval "content=\$$s"
    [[ -n "$content"  ]] || return 1
    [[ "$content" == "UNKNOWN" ]] && return 1
    return 0
}

# check key have been set to non defaults values
message_info_show "Checking config ..."
for key in `echo ${!CONFIG_*}`
do
    eval "value=\$$key"
    is_config_key_set "$key" || message_error_show "$key not set. Current value: $value"
    is_config_key_set "$key" || exit 1
    message_info_show "$key=$value"
done

# ask for confirmation
printf "Satisfied with configuration values ? (y/n)"
if test BOOTSTRAP_MODE != "noninteractive"; then
    accept="Y"
else
    read -n 1 -r accept
fi
echo    # (optional) move to a new line
if [[ ! $accept =~ ^[Yy]$ ]]
then
    message_info_show "Cancelled"
    exit 0
fi
