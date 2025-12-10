local function config()
    require('yazi').setup({
        -- open with yazi istead of netrw
        -- REQUIRES: loaded_netrwPlugin = 1
        open_for_directories = true
    })
    vim.g.loaded_netrwPlugin = 1
end

return {config = config}
