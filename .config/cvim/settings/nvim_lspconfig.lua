-- src: https://github.com/neovim/nvim-lspconfig
local function mapping_diagnostics()
    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    -- Show diagnostics in a floating window
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    -- Move to the previous diagnostic
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    -- Move to the next diagnostic
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
end

-- src: https://github.com/neovim/nvim-lspconfig
local function setup_keybinding_when_lspserver_attach_to_buffer()
    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        -- -- ommi-func: manual completion
        -- -- nvim-cmp  : auto completion
        -- - Disable ommi-func for nvim-cmp: https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
        -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        -- Jump to the definition
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        -- Displays hover information about the symbol under the cursor
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        -- Lists all the implementations for the symbol under the cursor
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        -- Displays a function's signature information
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        -- Jumps to the definition of the type symbol
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        -- Renames all references to the symbol under the cursor
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        -- Selects a code action available at the current cursor position
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        -- Lists all the references
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
        end, opts)
    end,
    })
end

local function setup_lsp(vim_lsp, lsp_name, client_lsp_capabilities, settings, flags)
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
    -- the LSP client support so that the LSP server can serve those completion canditates 
    local client_lsp_capabilties = cmp.default_capabilities(default_capabilities)

    -- default
    setup_lsp(
        vim_lsp,
        "*",
        default_capabilities,
        {},
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
        {},
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

    mapping_diagnostics()
    setup_keybinding_when_lspserver_attach_to_buffer()
end

return {config = config}
