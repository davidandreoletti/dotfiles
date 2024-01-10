# Swap 2 files/or directories
# Usage: swap file1 file2
alias swap='f_file_directory_swap '

# Find largest directory, sorted by largest to smaller
# https://serverfault.com/a/156648
# regquires gnu coreutils
alias largest_dirs_asc='du -hs * | sort -h'

# Create file and possibly missing parent
# usage: touch /path/to/missing/dir/file.txt
alias touch='f_file_directory_create_missing_dirs_file '
