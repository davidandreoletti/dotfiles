local function config()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
        ensure_installed = { "lua", "vim", "vimdoc" },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },  
    })
end

return {config = config}
