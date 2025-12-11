-- Code completion/action on LSP enabled buffers. See `:help lsp-defaults
-- Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        -- -- ommi-func : manual completion
        -- -- nvim-cmp  : auto completion
        -- - Disable ommi-func for nvim-cmp: https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
        -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- NOTE: See `:help vim.lsp.*` for functions definition

        -- NOTE:
        -- Q1: How to know if vim.lsp.protocol.Methods.textDocument_completion is defined ?
        -- A1: See https://raw.githubusercontent.com/neovim/neovim/d2e445e1bd321ea43b976d6aa7759d90b826ce62/runtime/lua/vim/lsp/protocol.lua
        -- Q2: How to know the LSP method name ?
        -- Q2: See https://microsoft.github.io/language-server-protocol/specifications/lsp/3.18/specification/#textDocument_codeAction

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local buffer = ev.buf
        local opts = { buffer = buffer }

        -- Enable completion support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
            vim.opt.completeopt = {'menu', 'menuone', 'noinsert', 'fuzzy', 'popup'}
            vim.lsp.completion.enable(true, client.id, buffer, {autotrigger = true})
            vim.keymap.set(
                'i', '<C-Space>',
                function()
                    -- Retrieve LSP completion candidates
                    vim.lsp.completion.get()
                end, 
                {
                    desc = 'Trigger LSP completion'
                }
            )
        end
        -- Enable LLM-based completion support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion) then
            vim.opt.completeopt = {'menu', 'menuone', 'noinsert', 'fuzzy', 'popup'}
            vim.lsp.inline_completion.enable(true, { client_id = client.id, buffer = buffer})
            vim.keymap.set(
                'i', '<Tab>', 
                function()
                    -- Retrieve LSP completion candidates
                    if not vim.lsp.inline_completion.get() then
                        return "<Tab>"
                    end
                end,
                {
                    desc = 'Apply the current inline completion suggestion',
                    expr = true,
                    buffer = buffer
                }
            )
            vim.keymap.set(
                'i', '<M-n>',
                function()
                    vim.lsp.inline_completion.select({})
                end,
                {
                    desc = 'Show next inline completion suggestion',
                    buffer = buffer
                }
            )
            vim.keymap.set(
                'i', '<M-p>',
                function()
                    vim.lsp.inline_completion.select({count = -1})
                end,
                {
                    desc = 'Show previous inline completion suggestion',
                    buffer = buffer
                }
            )
        end
        -- Enable code lens support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
            local gid = vim.api.nvim_create_augroup("UserLSPDocumentCodeLens", { clear = true })
            vim.api.nvim_create_autocmd({"CursorHold","InsertLeave"}, {
                group = gid,
                buffer = buffer,
                callback = function()
                    vim.lsp.codelens.refresh({ bufnr = buffer })
                end,
                desc = "Display code lens"
            })
        end
        -- Enable diagonstic support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_diagnostic) then
            -- FIXME what to do ?
        end
        -- Enable declaration support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_declaration) then
            vim.keymap.set(
                'n', 'gD',
                vim.lsp.buf.declaration,
                {
                    desc = "Jump to declaration",
                    buffer = buffer
                }
            )
        end
        -- Enable definition support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
            vim.keymap.set(
                'n', 'gd',
                vim.lsp.buf.definition,
                {
                    desc = "Jump to definition",
                    buffer = buffer
                }
            )
        end
        -- Enable hover support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_hover) then
            vim.keymap.set(
                'n', 'K',
                vim.lsp.buf.hover,
                {
                    desc = "Display symbol info",
                    buffer = buffer
                }
            )
        end
        -- Enable implementation support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
            vim.keymap.set(
                'n', 'gi',
                vim.lsp.buf.implementation,
                {
                    desc = "List symbol implementations",
                    buffer = buffer
                }
            )
        end
        -- Enable signature help completion support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp) then
            -- Displays a function's signature information
            vim.keymap.set(
                'n', '<C-k>', 
                vim.lsp.buf.signature_help,
                {
                    desc = "Trigger LSP signature help",
                    buffer = buffer
                }
            )
        end
        -- Enable workspace support
        if client:supports_method(vim.lsp.protocol.Methods.workspace_didChangeWorkspaceFolders) then
            vim.keymap.set(
                'n', '<space>wa',
                vim.lsp.buf.add_workspace_folder,
                {
                    desc = "Add workspace folder",
                    buffer = buffer
                }
            )
            vim.keymap.set(
                'n', '<space>wr',
                vim.lsp.buf.remove_workspace_folder,
                {
                    desc = "Remove workspace folder",
                    buffer = buffer
                }
            )
        end
        if client:supports_method(vim.lsp.protocol.Methods.workspace_workspaceFolders) then
            vim.keymap.set(
                'n', '<space>wl',
                function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end,
                {
                    desc = "List workspaces",
                    buffer = buffer
                }
            )
        end
        -- Enable definition support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
            vim.keymap.set(
                'n', '<space>D',
                vim.lsp.buf.type_definition,
                {
                    desc = "Jumps to type symbol definition",
                    buffer = buffer
                }
            )
        end
        -- Enable rename support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
            vim.keymap.set(
                'n', '<space>rn',
                vim.lsp.buf.rename,
                {
                    desc = "Renames all references",
                    buffer = buffer
                }
            )
        end
        -- Enable code action support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
            vim.keymap.set(
                { 'n', 'v' }, '<space>ca', 
                vim.lsp.buf.code_action,
                {
                    desc = "Selects a code action", 
                    buffer = buffer
                }
            )
        end
        -- Enable references support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_references) then
            vim.keymap.set(
                'n', 'gr',
                vim.lsp.buf.references,
                {
                    desc = "List all references",
                    buffer = buffer
                }
            )
        end
        -- Enable Document Highlight support
        if client.server_capabilities.documentHighlightProvider then
            local gid = vim.api.nvim_create_augroup("UserLSPDocumentHighlight", { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
                group = gid,
                buffer = buffer,
                callback = function()
                    vim.lsp.buf.document_highlight()
                end,
                desc = "Highlight current variable and usage in buffer"
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = gid,
                buffer = bufnr,
                callback = function()
                vim.lsp.buf.clear_references()
                end,
                desc = "Clear references"
            })
        end
        -- Enable document color support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentColor) then
            vim.lsp.document_color.enable(true, buffer)
        end
        -- Enable Inlay hint support
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, {buffer = buffer})
            local gid = vim.api.nvim_create_augroup("UserLSPDocumentHighlight", { clear = true })
            vim.keymap.set(
                "n", "<leader>h",
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end,
                {
                    desc = "Toggel inlay hint",
                    buffer = buffer,
                }
            )
        end
        -- Enable Call Hierarchy support
        if client:supports_method(vim.lsp.protocol.Methods.callHierarchy_incomingCalls) then
            vim.keymap.set(
                'n', 'gri',
                vim.lsp.buf.incoming_calls,
                {
                    desc = "Lists all incoming call sites",
                    buffer = buffer
                }
            )
        end
        if client:supports_method(vim.lsp.protocol.Methods.callHierarchy_outgoingCalls) then
            vim.keymap.set(
                'n', 'gro',
                vim.lsp.buf.outgoing_calls,
                {
                    desc = "Lists all outgoing call sites",
                    buffer = buffer
                }
            )
        end
        -- Enable formatting support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
            vim.keymap.set(
                'n', '<space>f', 
                function()
                    vim.lsp.buf.format { async = true }
                end,
                { 
                    desc = "Format buffer",
                    buffer = buffer 
                }
            )
        end
        -- Enable incremental selection support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_selectionRange) then
            vim.keymap.set(
                'n', '<space>+',
                function()
                    vim.lsp.buf.section_range('outer', 1000) { async = true }
                end,
                {
                    desc = "LSP select outward",
                    buffer = buffer
                }
            )
            vim.keymap.set(
                'n', '<space>-',
                function()
                    vim.lsp.buf.section_range('inner', 1000) { async = true }
                end,
                {
                    desc = "LSP select inward",
                    buffer = buffer
                }
            )
        end
        -- Enable linked editing range support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_linkedEditingRange) then
            vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
        end
        -- Enable semantic token support
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_semanticTokens_full) then
            vim.lsp.semantic_tokens.enable(true, { client_id = client.id, buffer = buffer })
        end
    end,
    nested = true,
    desc = "Configure buffer keymap and LSP based behaviour"
})
