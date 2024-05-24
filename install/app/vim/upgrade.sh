if command -v 'vim'; then 
    command vim +'PlugClean --sync' +qa >/dev/null 2>&1
    command vim +'PlugUpgrade --sync' +qa >/dev/null 2>&1
    command vim +'PlugInstall --sync' +qa >/dev/null 2>&1
    command vim +'PlugUpdate --sync' +qa >/dev/null 2>&1
fi
