" Hide leading heading stars
let g:org_heading_shade_leading_stars = 1
" Keywords in headings
let g:org_todo_keywords = [
    \ ['TODO(t)', 'WIP(w)', 'BLOCK(b)', '|', 'DONE(d)', 'DELEGATED', 'CANCELLED']
    \ ]
" Colored keywords
let g:org_todo_keyword_faces = [
      \   ['TODO', 
      \        [ ':foreground red', ':background black' ]
      \   ],
      \   ['WIP', 
      \        [ ':foreground yellow', ':background black' ]
      \   ],
      \   ['BLOCK', 
      \        [ ':foreground #ff00ff', ':background blue', ':weigh bold', ':slant italic' ]
      \   ],
      \   ['DONE', 
      \        [ ':foreground lightgreen', ':background black' ]
      \   ],
      \   ['DELEGATED', 
      \        [ ':foreground green', ':background black' ]
      \   ],
      \   ['CANCELLED', 
      \        [ ':foreground darkgrey', ':background black' ]
      \   ],
      \]
" Ident body of text to the same level as the heading
let g:org_indent = 1
