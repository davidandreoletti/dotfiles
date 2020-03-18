# Enable vi mode
# - enabled via see $HOME/.inputrc

# Bash options.
# https://www.gnu.org/software/bash/manual/bashref.html#The-Shopt-Builtin

# Automatically prepend `cd` to directory names.
#shopt -s autocd

# Check the window size after each command and, if necessary, update
# the values of `LINES` and `COLUMNS`.
shopt -s checkwinsize

# Include filenames beginning with a "." in the filename expansion.
shopt -s dotglob

# Use extended pattern matching features.
shopt -s extglob

# Do not attempt to search the PATH for possible completions when
# completion is attempted on an empty line.
shopt -s no_empty_cmd_completion

# Match filenames in a case-insensitive fashion when performing
# filename expansion.
shopt -s nocaseglob

