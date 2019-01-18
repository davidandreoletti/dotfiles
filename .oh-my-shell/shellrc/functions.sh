#
# Get os
#
get_os_type() {
    case "$OSTYPE" in
        darwin*)  echo "macosx" ;;
        linux*)   echo "linux" ;;
        *)        echo "unknown" ;;
    esac
}
