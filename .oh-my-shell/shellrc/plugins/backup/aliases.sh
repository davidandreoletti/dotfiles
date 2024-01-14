# % backup, folder
# # Duplicate a file/directory. Duplicated backup are suffixed with the next available number (as [ddd])
# ; usage: backup <mydir>
# #        => produces mydir-000
alias backup="f_backup_duplicate_with_simple_numbering"

# % backup, ignore, folder
# # Mark directory to not be backup by rsync (for consumption by my own custom rsync backup script)
# ; usage: backup_ignore_directory
alias backup_ignore_directory="echo \"- /*\" > .backup.ignore"
