local function config()
    -- Setup treesitter
    require('nvim-treesitter.configs').setup({
        highlight = {
           enable = true,
           disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
           additional_vim_regex_highlighting = { 'org' }, -- Required since TS highlighter doesn't support all syntax features (conceal)
        },
        ensure_installed = {'org'},
    })

    -- Setup orgmode
    -- doc: https://github.com/nvim-orgmode/orgmode/blob/master/DOCS.md
    require('orgmode').setup({
        -- File locations
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
        -- Keywords in headings
        org_todo_keywords = {'TODO(t)', 'WIP(w)', 'BLOCK(b)', '|', 'DONE(d)', 'DELEGATED', 'CANCELLED' },
        -- Colored keywords
        org_todo_keyword_faces = {
            TODO = ':foreground red :background black',
            WIP = ':foreground yellow :background black',
            BLOCK = ':foreground blue :background black',
            DONE = ':foreground lightgreen :background black',
            DELEGATED = ':foreground green :background black',
            CANCELLED = ':foreground darkgrey :background black'
        },
        -- Hide leading heading starts
        org_hide_leading_stars = true,
        -- Custom mapping
        mappings = {
            global = {
                org_agenda = '<Leader>oa',
                org_capture = '<Leader>oc'
            }
        },
    })
end

return {config = config}
