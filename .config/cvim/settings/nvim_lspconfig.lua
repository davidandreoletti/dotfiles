local function setup_lsp(vim_lsp, lsp_name, client_lsp_capabilities, settings, flags)
    -- lsp_name = A lua file name in https://github.com/neovim/nvim-lspconfig/blob/master/lsp

    -- Extend config for a language
    vim_lsp.config(lsp_name,{
        -- Enable LSP with additional completion capabilities
        capabilities = client_lsp_capabilities,
        -- LSP setting
        settings = settings,
        -- LSP flags
        flags = flags,
    })

    -- Enable the config
    -- - Mason's automatic_enable call: vim.lsp.enable(lsp_name)
    -- - NOTE: To check a LSP configuratio is enabled, run :checkhealth vim.lsp and expect to find it under "Active Configurations"
end

local function config()
    -- Setup Language servers

    -- IMPORTANT: Each call to setup_lsp() trigers:
    --            - a request to install the language server binaries (via mason)
    --            - setup the LSP
    --
    -- IMPORTANT: Mapping between a lspconfig's LSP name and Mason's LSP name found here:
    --   - https://mason-registry.dev/registry/list

    local vim_lsp = vim.lsp
    local default_capabilities = vim_lsp.protocol.make_client_capabilities()
    local cmp = require('cmp_nvim_lsp')
    -- cmp-nvim supports different completion results (ie capabilities) on top of
    -- neovim's omnifunc capability.
    -- cmp-nvim is a LSP client, it must indicate to the LSP server what capabilities
    -- the LSP client support so that the LSP server can serve those completion canditates,
    -- in addition to the default capabilities
    local client_lsp_capabilties = cmp.default_capabilities(default_capabilities)

    -- default
    setup_lsp(
        vim_lsp,
        "*",
        default_capabilities,
        {
            root_markers = {".git" }
        },
        {
            debounce_text_changes = 200
        }
    )
    -- python
    setup_lsp(
        vim_lsp,
        "ruff",
        client_lsp_capabilties,
        {},
        {}
    )
    setup_lsp(
        vim_lsp,
        "pylsp",
        client_lsp_capabilties,
        {
          black = { enabled = false },
          autopep8 = { enabled = false },
          yapf = { enabled = false },
          -- linter options
          pylint = { enabled = false, executable = "pylint" },
          ruff = { enabled = true },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
          -- type checker
          pylsp_mypy = {
            enabled = true,
            overrides = { "--python-executable", py_path, true },
            report_progress = true,
            live_mode = false
          },
          -- auto-completion options
          jedi_completion = { fuzzy = true },
          -- import sorting
          isort = { enabled = false },
        },
        {}
    )
    -- vimL
    setup_lsp(
        vim_lsp,
        "vimls",
        client_lsp_capabilties,
        {},
        {}
    )
    -- terraform
    setup_lsp(
        vim_lsp,
        "terraformls",
        client_lsp_capabilties,
        {},
        {}
    )
    -- rust
    setup_lsp(
        vim_lsp,
        "rust_analyzer",
        client_lsp_capabilties,
        {},
        {}
    )
    -- markdown
    setup_lsp(
        vim_lsp,
        "marksman",
        client_lsp_capabilties,
        {},
        {}
    )
    -- lua
    setup_lsp(
        vim_lsp,
        "lua_ls",
        client_lsp_capabilties,
        {
            Lua = {
                hint = { enable = true, semicolon = "Disable" },
                diagnostics = {
                    globals = {
                        -- recognize 'vim' as global variable
                        "vim",
                    }
                },
                workspace = {
                    library = {
                        -- lua runtime
                        vim.api.nvim_get_runtime_file("", true)
                    }
                },
                telemetry = { enable = false }
            }
        },
        {}
    )
    -- latex
    setup_lsp(
        vim_lsp,
        "ltex",
        client_lsp_capabilties,
        {},
        {}
    )
    -- json
    setup_lsp(
        vim_lsp,
        "jsonls",
        client_lsp_capabilties,
        {},
        {}
    )
    -- yaml
    setup_lsp(
        vim_lsp,
        "yamlls",
        client_lsp_capabilties,
        {},
        {}
    )
    -- html
    setup_lsp(
        vim_lsp,
        "html",
        client_lsp_capabilties,
        {},
        {}
    )
    -- dockerfile
    setup_lsp(
        vim_lsp,
        "dockerls",
        client_lsp_capabilties,
        {},
        {}
    )
    -- clojure
    setup_lsp(
        vim_lsp,
        "clojure_lsp",
        client_lsp_capabilties,
        {},
        {}
    )
    -- astrojs
    setup_lsp(
        vim_lsp,
        "astro",
        client_lsp_capabilties,
        {},
        {}
    )
    -- harper-js
    setup_lsp(
        vim_lsp,
        'harper_ls',
        client_lsp_capabilties,
        {},
        {}
    )
    -- bash
    setup_lsp(
        vim_lsp,
        'bash_ls',
        client_lsp_capabilties,
        {}
    )
    -- typescript
    setup_lsp(
        vim_lsp,
        'ts_ls',
        client_lsp_capabilties,
        {}
    )
    -- Github Copilot
    setup_lsp(
        vim_lsp,
        'copilot',
        client_lsp_capabilties,
        {},
        {}
    )
end

return {config = config}
