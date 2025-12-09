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
        -- avoid trying to install an unknown linter
        ignore_install = {}
    })
end

return {config = config}
