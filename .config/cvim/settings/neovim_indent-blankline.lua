local function config()
    require('ibl').setup({
        indent = { char = "┊", tab_char = "|"},
    })
end

return {config = config}
