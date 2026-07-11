# Import data from z only if z has been initialized
if test -n "${_Z_DATA}"; then
    zoxide import --merge --from=z "${_Z_DATA}"
fi
