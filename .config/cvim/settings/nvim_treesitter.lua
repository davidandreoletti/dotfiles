local function config()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
        ensure_installed = {
            "lua",
            "vim",
            "vimdoc",
            "typescript",
            "markdown",
            "markdown_inline",
            "python",
            "css",
            "html",
            "gitignore",
            "yaml",
            "latex"
        },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `treesitter` CLI installed locally
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = { 'help' } -- List of language to disable for
        },
        indent = {
          enable = true
        },
        autotags = {
          enable = true
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-n>",
            node_incremental = "<C-n>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-m>",
          }
        },
    })
end

return {config = config}
