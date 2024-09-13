# Swap 2 files/or directories
# Usage: swap file1 file2
alias swap='f_file_directory_swap '

# Create file and possibly missing parent
# usage: touch /path/to/missing/dir/file.txt
alias touch='f_file_directory_create_missing_dirs_file 1 '

# Create file and possibly missing parent, then edit
# usage: touch /path/to/missing/dir/file.txt
alias edit='f_file_directory_create_missing_dirs_file 0 '

# Find all broken symbolic links
# usage: find_broken_symbolic_link /path/to/some/folder
alias find_broken_symbolic_link='find -L -xtype l'

# Disk usage analyzer
# usage: tdiskusage /path/to/some/folder
alias tdiskusage='dua interactive '
