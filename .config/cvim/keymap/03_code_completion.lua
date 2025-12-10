-- Code completion/action on LSP enabled buffers. See `:help lsp-defaults
-- Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
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
        -- Add to workspace 
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- Remove from workspace 
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- List workspaces 
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
        -- Lists all incoming call sites of the symbol under the cursor in the quickfix window
        -- User can pick one site in the input list
        vim.keymap.set('n', 'gri', vim.lsp.buf.incoming_calls, opts)
        -- Lists all outgoing call sites of the symbol under the cursor in the quickfix window
        -- User can pick one site in the input list
        vim.keymap.set('n', 'gro', vim.lsp.buf.outgoing_calls, opts)
        -- Set some key bindings conditional on server capabilities
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)

        -- FIXME: Continue with https://github.com/jdhao/nvim-config/blob/4d8ef868ad0ef7f6433d91332aa6649186d9a2fb/lua/config/lsp.lua
    end,
})
