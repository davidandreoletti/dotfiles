" VimInfo
" Move viminfo to a central location
" src: https://stackoverflow.com/a/23036077
let &viminfo="%,<800,\'10,/50,:100,h,f0,n".vimDistributionRootDir."/cache/viminfo/".g:vimDistribution.'/viminfo'
"            | |    |   |   |    | |    + viminfo file path
"            | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"            | |    |   |   |    + disable 'hlsearch' loading viminfo
"            | |    |   |   + command-line history saved
"            | |    |   + search history saved
"            | |    + files marks saved
"            | + lines saved each register (old name for <, vi6.2)
"            + save/restore buffer list

