let g:list_of_normal_keys = [ "h", "j", "k", "l", "-", "+" ]
let g:list_of_visual_keys = [ "h", "j", "k", "l", "-", "+" ]
" Disable hardtime by default
let g:hardtime_default_on = 0
" Max time a char can be repeated within |hardtime_timeout| duration
" eg: j   -> ok
"     jj  -> ok
"     jjj -> not allowed
let g:hardtime_maxcount = 2
" Using a key with a count (5j) will lead to a reset of the key's count.
let g:hardtime_motion_with_count_resets = 1
" Allow a key when it is different from the previous key
let g:hardtime_allow_different_key = 1
" Reset key count after timeout in milliseconds 
let g:hardtime_timeout = 2000
" Notify when HardTime is enabled
let g:hardtime_showmsg = 1
" Hardtime disabled on quickfix window  
let g:hardtime_ignore_quickfix = 1
" Hardtime disabled on certain buffer patterns
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]

