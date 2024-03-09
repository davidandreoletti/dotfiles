local function config()
    -- Setup lspconfig-mason based on ':h masson-lspconfig automatic-server-setup'
    require('mason-lspconfig').setup({
         -- LSPs to install is defined in lspconfig's nvim_lspconfig.lua.
         -- So no need configure these settings here:
         -- - ensure_installed = {},
         automatic_installation = true
    })

    -- However, define a default handler for LSPs not defined in nvim_lspconfig.lua
    require('mason-lspconfig').setup_handlers({
        function (server_name) -- default handler
            require("lspconfig")[server_name].setup {}
        end,
    })
end

return {config = config}
