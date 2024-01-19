local function config()
    -- Setup mason
    require('mason').setup({
        log_level = vim.log.levels.DEBUG,
        max_concurrent_installers = 8,
        pip = {
            upgrade_pip = true,
        },
    })

end

return {config = config}
