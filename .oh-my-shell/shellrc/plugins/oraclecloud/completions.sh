# oci completions supported on bash only
is_bash && command_exists oci && { source $(homebrew_package_path_prefix "oci-cli")/libexec/lib/python*/site-packages/oci_cli/bin/oci_autocomplete.sh} >/dev/null 2>&1
