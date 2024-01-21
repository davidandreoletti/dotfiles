" Undo
" Move undo files to a central location
let s:undirPath=vimDistributionRootDir."/cache/undo/".g:vimDistribution."//"
let &undodir=s:undirPath
set undofile
