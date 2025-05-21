local function config()
    -- Setup lspconfig-mason based on ':h masson-lspconfig automatic-server-setup'
    require('mason-lspconfig').setup({
         -- LSPs to install is defined in lspconfig's nvim_lspconfig.lua.
         -- So no need configure these settings here:
         -- - ensure_installed = {},
         automatic_enable = true
    })
end

return {config = config}
