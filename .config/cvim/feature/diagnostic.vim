lua << EOF
if vim.fn.has('nvim') == 1 then
    vim.diagnostic.config({
    virtual_text = false,                  -- diagnostic shows up inline with code statment
    virtual_lines = {current_line = true}, -- diagnostic shows up for current line 
    underline = false,
    update_in_insert = false,              -- Do not update diagnostic in Insert Mode. 
    severity_sort = false,                 -- Do not sort diagnostic by severity
    })
end
EOF
