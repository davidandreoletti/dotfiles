# Duplicate a file/directory. Duplicated backup are suffixed with the next available number (as [ddd])
# Usage: backup mydir
#        => produces mydir-000
alias backup="f_backup_duplicate_with_simple_numbering"

# Mark directory to not be backup by rsync (for consumption by my own custom rsync backup script)
alias backupMarkDirectoryAsIgnored="echo \"- /*\" > .backup.ignore"

# Backups
# for duplicity based backups
alias backupignoredir="touch .backup.ignore"


