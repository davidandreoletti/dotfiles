# oci may not be installed on all machines, conditionally load oci shell completions
command_exists oci && eval "$(_OCI_COMPLETE=source oci)"
