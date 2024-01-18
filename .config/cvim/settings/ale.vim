" Globals
" Use global executable
let g:ale_use_global_executables=1
"
" FIXERS
"

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1
" Fixers
let g:ale_fixers = {
\   '*':          ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'json':       ['prettier'],
\   'jsonc':      ['prettier'],
\   'rust':       ['rustfmt'],
\   'python':     ['ruff', 'ruff_format'],
\}

"
" LINTERS
"
let g:ale_linters_explicit = 1
let g:ale_echo_msg_format = '%linter%:%type%:%code%: %s'
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'rust':       ['analyzer'],
\   'python':     ['pyright', 'ruff'],
\   'sh':         ['shellcheck', 'shfmt'],
\   'yaml':       ['yamllint'],
\   'xml':        ['xmllint'],
\   'tex':        ['chktex'],
\   'terraform':  ['terraform'],
\   'markdown':   ['markdown'],
\   'awk':        ['gawk'],
\}

"
" COMPLETIONS
"
" Enable completion where available.
" This setting must be set before ALE is loaded.
"
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 1
