function! F_FeatureEnabledOn(distrib, distribVIM, distribNVIM, distribIDEAVIM, distribUnknown)
        if a:distrib ==# g:VIM_FLAVOR_VIM
            return a:distribVIM
        elseif a:distrib ==# g:VIM_FLAVOR_NEOVIM
            return a:distribNVIM
        elseif a:distrib ==# g:VIM_FLAVOR_IDEAVIM
            return a:distribIDEAVIM
        else
            return a:distribUnknown
        endif
endfunction

" Source a file
function! F_Source (vim_distribution,file)
    if a:vim_distribution ==# g:VIM_FLAVOR_VIM
        exe 'source ' . a:file 
    elseif a:vim_distribution ==# g:VIM_FLAVOR_NEOVIM
        exe 'source ' . a:file 
    elseif a:vim_distribution ==# g:VIM_FLAVOR_IDEAVIM
        exe 'source ' . a:file 
    endif
endfunction

" Load feature + associated settings when enabled
function! F_IsFeatureEnabled (featureFlags, vim_distribution, feature)
    return has_key(a:featureFlags, a:feature) && a:featureFlags[a:feature]
endfunction

" Load feature + associated settings when enabled
function! F_Feature (featureFlags, vim_distribution, feature)
    if F_IsFeatureEnabled(a:featureFlags, a:vim_distribution, a:feature)
            let path = g:cvimFeaturePath . "/" . a:feature . ".vim"
            if g:cvimFeatureDebugLoading
                echom "Loading feature: " . a:feature . " from " . path
            endif
            call F_Source(a:vim_distribution, path)
    endif
endfunction
