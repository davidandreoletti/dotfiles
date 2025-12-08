local function config()
    -- Setup whichkey_setup
    require("whichkey_setup").config({
        hide_statusline = false,
        default_keymap_settings = {
            silent=true,
            noremap=true,
        },
        default_mode = 'n',
    })
end

return {config = config}
