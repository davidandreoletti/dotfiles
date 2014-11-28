###############################################################################
# Config file
# Format:
# Key0=Value0
# Key1=Value1
###############################################################################

# FIXME dummy value + restore to UNKNOWN
CONFIG_MACOSX_VNC_PASSWORD="ASUNKNOWN"
CONFIG_MACOSX_USER_ADMIN_PASSWORD="dummy"

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
echo "Satisfied with configuration values ? (y/n)"
read -p "" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    message_info_show "Cancelled"
    exit 0
fi
