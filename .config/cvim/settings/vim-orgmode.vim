if g:vimFlavor ==# g:VIM_FLAVOR_VIM
    " Non text highlighting hiding leading * char for each heading
    let g:org_heading_shade_leading_stars = 1
    " Keywords highlighted in headings
    let g:org_todo_keywords = [
        \ ['TODO(t)', 'WIP(w)', 'BLOCK(b)', '|', 'DONE(d)'],
        \ ['CANCELLED(c)']] 
    " Ident body of text to the same level as the heading
    let g:org_indent = 1
endif
