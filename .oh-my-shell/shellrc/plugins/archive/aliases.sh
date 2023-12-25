# Uncompress nearly any archive
alias uco='unp'

# Archive as zip file each root level folder in the specified path
# Usage: archiveEachFolderSeparatidely "/path/to/a/folder"
alias archiveEachFolderSeparatidely='f_archiveEachFolderSeparatedely'

# Archive as tar.gz the specified folder
# Usage: archiveFolder /path/to/my/folder
# - Note: archive name is archive.tar.gz
alias archiveFolder='tar -cafv archive.tar.zstd '

# Send a directory over the network fast
# companion app: archiveReceiveFromNetwork
# Usage: archiveToNetwork 192.168.3.101 1234
alias archiveSendToNetwork='f_archiveSendToNetwork'

# Receive a directory over the network fast
# companion app: archiveSendToNetwork
# Usage: archiveToNetwork 1234
alias archiveReceiveFromNetwork='f_archiveReceiveFromNetwork'
