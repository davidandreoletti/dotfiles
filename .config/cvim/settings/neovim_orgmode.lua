local function config()
    -- Load treesitter grammar for org
    require('orgmode').setup_ts_grammar()

    -- Setup treesitter
    require('nvim-treesitter.configs').setup({
        highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'org' },
        },
        ensure_installed = { 'org' },
    })

    -- Setup orgmode
    require('orgmode').setup({
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
        -- Custom keywords for unfinished / finished states
        org_todo_keywords = {'TODO(t)', 'WIP(w)', 'BLOCKED(b)', '|', 'DONE(d)', 'DELEGATED'},
        -- Custom color for todo keywords
        --org_todo_keyword_faces = {
        --    WAITING = ':foreground blue :weight bold',
        --    DELEGATED = ':background #FFFFFF :slant italic :underline on',
        --    TODO = ':background #000000 :foreground red',
        --}
        -- Hide leading starts
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
