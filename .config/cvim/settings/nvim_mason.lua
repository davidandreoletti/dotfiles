local function config()
    -- Setup mason
    require('mason').setup({
        log_level = vim.log.levels.DEBUG,
        max_concurrent_installers = 8,
        pip = {
            upgrade_pip = true,
        },
    })

    -- Auto update all mason managed resources
    -- src: https://github.com/mason-org/mason.nvim/discussions/1241#discussioncomment-5701984
    vim.api.nvim_create_user_command("MasonUpgradeAll", function()
        local registry = require("mason-registry")
        registry.refresh()
        registry.update()
        local packages = registry.get_all_packages()
        for _, pkg in ipairs(packages) do
            if pkg:is_installed() then
                pkg:install()
            end
        end
        vim.cmd("doautocmd User MasonUpgradeAllComplete")
    end, { force = true })

end

return {config = config}
