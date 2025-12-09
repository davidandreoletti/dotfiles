local function config()
    require('mason-nvim-lint').setup({
        ensure_installed = { 
            'ruff',
            --'alex',
            'actionlint',
            --'commitlint',
            'hadolint',
            'htmlhint',
            --'kubelinter',
            --'luacheck',
            'shellcheck',
            'shellharden',
            'yamllint',
        }, 
        -- Avoid trying to install an unknown linter
        ignore_install = {
            'ruby',
            'clj-kondo',
            'inko',
            'janet'
        }
    })
end

return {config = config}
