local function config()
    -- Setup hop
    require('mason-lspconfig').setup({
         -- Which LSPs to install is defined by lspconfig's nvim_mason_lspconfig.lua.
         -- So no need configure these settings
         -- - ensure_installed = {},
         -- - automatic_installation = false,
    })

end

return {config = config}
