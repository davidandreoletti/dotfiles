let g:list_of_normal_keys = [ "h", "j", "k", "l", "-", "+" ]
let g:list_of_visual_keys = [ "h", "j", "k", "l", "-", "+" ]
" Enable hardtime by default
"let g:hardtime_default_on = 1
" Max time a char can be repeated within |hardtime_timeout| duration
" eg: j  -> ok
"     jj -> ok
let g:hardtime_maxcount = 2
" eg: 5j is allowed. jjjjj is not
let g:hardtime_motion_with_count_resets = 1
" allow a key when it is different from the previous key
let g:hardtime_allow_different_key = 1
" 
let g:hardtime_timeout = 2000
" Notify when HardTime is enabled
let g:hardtime_showmsg = 1
" Hardtime disabled on quickfix window  
let g:hardtime_ignore_quickfix = 1


