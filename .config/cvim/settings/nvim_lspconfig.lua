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
local function mapping_goto()
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

local function setup_lsp(lspconfig, lsp_capabilities, lsp_name)
    -- Install + Setup LSP
    lspconfig[lsp_name].setup({
        -- Enable LSP with additional completion capabilities
        capabilities = lsp_capabilities,
    })
end

local function config()
    -- Setup Language servers
    local lspconfig = require('lspconfig')

    -- IMPORTANT: Each call to setup_lsp() trigers:
    --            - a request to install the language server binaries (via mason)
--  --            - setup the LSP
--  --
    -- - mapping between a lspconfig's LSP name and Mason's LSP name found here:
    --   - https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md

    local cmp = require('cmp_nvim_lsp')
    local lsp_cmp_capabilities = cmp.default_capabilities()

    -- Python
    setup_lsp(lspconfig, lsp_cmp_capabilities, "ruff")
    setup_lsp(lspconfig, lsp_cmp_capabilities, "pylsp")
    -- vimL
    setup_lsp(lspconfig, lsp_cmp_capabilities, "vimls")
    -- terraform
    setup_lsp(lspconfig, lsp_cmp_capabilities, "terraformls")
    -- rust
    setup_lsp(lspconfig, lsp_cmp_capabilities, "rust_analyzer")
    -- markdown
    setup_lsp(lspconfig, lsp_cmp_capabilities, "marksman")
    -- lua
    setup_lsp(lspconfig, lsp_cmp_capabilities, "lua_ls")
    -- latex
    setup_lsp(lspconfig, lsp_cmp_capabilities, "ltex")
    -- json
    setup_lsp(lspconfig, lsp_cmp_capabilities, "jsonls")
    -- html
    setup_lsp(lspconfig, lsp_cmp_capabilities, "html")
    -- dockerfile
    setup_lsp(lspconfig, lsp_cmp_capabilities, "dockerls")
    -- clojure
    setup_lsp(lspconfig, lsp_cmp_capabilities, "clojure_lsp")
    -- astrojs
    setup_lsp(lspconfig, lsp_cmp_capabilities, "astro")

    mapping_diagnostics()
    mapping_goto()
end

return {config = config}
