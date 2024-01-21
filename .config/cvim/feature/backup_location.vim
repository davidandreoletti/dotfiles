" Backups
" Move backup files to a central location
let s:backupDirPath=vimDistributionRootDir."/cache/backup/".g:vimDistribution
let &backupdir=s:backupDirPath
