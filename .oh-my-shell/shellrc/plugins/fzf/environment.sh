# Trigger sequence for fuzzy completion
# Eg:
# - vim **<TAB>
# - kill -9 <TAB>
# - ssh **<TAB>
# - For a complete list of commands supported: complete | grep _fzf
export FZF_COMPLETION_TRIGGER='**'

# Default fzf options
# --height fzf ui height, relative to containing shell/window
# --layout=reverse Top down listing
# --multi Select multiple files, instead of just one. Use <TAB> to select each file
# --no-mouse Power user mode :P
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --inline-info --multi --no-mouse'

# Fzf uses ripgrep as default command to search for files
# FIXME: Fallback to find if rg is not available
if command_exists rg; then
    export FZF_DEFAULT_COMMAND='rg --files 2> /dev/null'
fi
