# oci may not be installed on all machines, conditionally load oci shell completions
if command -v oci > /dev/null ];
then
    eval "$(_OCI_COMPLETE=source oci)"
fi
