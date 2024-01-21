" FIXME Rename VIM_FLAVOR to VIM_DISTRIBUTION
let g:VIM_FLAVOR_VIM = 'vim'
let g:VIM_FLAVOR_NEOVIM = 'neovim'
let g:VIM_FLAVOR_IDEAVIM = 'ideavim'
let g:VIM_FLAVOR_UNKNOWN = 'unknown'

" Get VIM distrib
" Returns:
" - vim
" - neovim  
" - ideavim  
" - unknown
function! F_Get_Vim_Distribution ()
    if has('nvim')
        return g:VIM_FLAVOR_NEOVIM
    elseif has('ide')
        return g:VIM_FLAVOR_IDEAVIM
    else
        return g:VIM_FLAVOR_VIM
    endif
endfunction

function! F_Get_Vim_Distribution_Root_Dir ()
    if g:vimDistribution ==# g:VIM_FLAVOR_NEOVIM
        return expand($HOME)."/.config/nvim"
    elseif g:vimDistribution ==# g:VIM_FLAVOR_IDEAVIM
        return expand($HOmE)."/.config/ideavim"
    elseif g:vimDistribution ==# g:VIM_FLAVOR_VIM
        return expand($HOME)."/.vim"
    endif
endfunction
