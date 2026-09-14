# Import data from z only if z has been initialized
if test -n "${_Z_DATA}"; then
    echo "Cannot import ${_Z_DATA} into zoxide at custom path is not supported"
    #zoxide import z --merge "${_Z_DATA}"
fi

if test -f "$HOME/.z"; then
    zoxide import z --merge # expected ~/.z
fi
