# Compress nearly anything into an archive
# usage: archive_compress foo/  foo.tar.gz
alias archive_compress='ouch compress'

# Uncompress nearly any archive
# usage: archive_uncompress foo.tar.gz
alias archive_uncompress='unp'

# Archive as zip file each root level folder in the specified path
# Usage: archive_each_root_folder_separatidely "/path/to/a/folder"
alias archive_each_root_folder_separatidely='f_archiveEachFolderSeparatedely'

# Archive as tar.gz the specified folder
# Usage: archive_folder /path/to/my/folder
# - Note: archive name is archive.tar.gz
alias archive_folder='tar -cafv archive.tar.zstd '

# Send a directory over the network fast
# companion app: archive_receive_from
# Usage: archive_send_to 192.168.3.101 1234
alias archive_send_to='f_archiveSendToNetwork'

# Receive a directory over the network fast
# companion app: archive_send_to
# Usage: archive_receive_from 1234
alias archive_receive_from='f_archiveReceiveFromNetwork'
