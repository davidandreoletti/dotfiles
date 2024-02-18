# Define compression levels / parallelism for several compressors
# such as ouch(+zstd),etc
export ZSTD_CLEVEL=5
export ZSTD_NBTHREADS=0

# % archive, compress
# # Compress nearly anything into an archive
# ; usage: archive_compress <folder_or_file> <archive_name.zst>
# ; usage: archive_compress <folder_or_file> <archive_name.tar.zst>
alias archive_compress='ouch compress '

# % archive, decompress
# # Uncompress nearly any archive
# ; usage: archive_uncompress <archive_name>
alias archive_uncompress='unp '

# % archive, compress, individually
# # Archive as zip file each root level folder in the specified path
# ; usage: archive_each_root_folder_separatidely <root_folder>
alias archive_each_root_folder_separatidely='f_archiveEachFolderSeparatedely '

# % archive, compress, folder, tar.zst
# # Archive as tar.gz the specified folder
# ; Usage: archive_folder <folder_name>
alias archive_folder='f_archiveFolder '

# % archive, compress, send, network
# # Send a directory over the network fast
# # u companion app: archive_receive_from
# ; usage: archive_send_to <destination_ip> <destination_port>
alias archive_send_to='f_archiveSendToNetwork '

# % archive, decompress, receive, network
# # Receive a directory over the network fast
# # uompanion app: archive_send_to
# ; usage: archive_receive_from <local_port>
alias archive_receive_from='f_archiveReceiveFromNetwork '
