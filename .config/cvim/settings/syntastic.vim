" Setup syntastic's status line
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
" Syntastic Error Window will be opened automatically when errors are
" detected and closed automatically when none are detected
let g:syntastic_auto_loc_list=1
" Syntastic show syntaxhighlighting to mark error (where possible)
let g:syntastic_enable_highlighting=1
" Syntastic custom error symbols according to error type
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
" C++ setup: https://github.com/scrooloose/syntastic/wiki/C--%3A---gcc
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_no_default_include_dirs = 1
let g:syntastic_cpp_auto_refresh_includes = 1
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_compiler = 'clang++'
" Javascript
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'  " Use project's eslint binary
let g:syntastic_javascript_eslint_args = ['--fix'] " --fix to fix warning/errors automatically
" Reload js file fixed with eslint --fix
" src: https://vi.stackexchange.com/a/11281
set autoread
" HTML5
let g:syntastic_html_tidy_exec = 'tidy5'

