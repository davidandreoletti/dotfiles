local function config()
    -- Setup lspconfig-mason based on ':h masson-lspconfig automatic-server-setup'
    require('mason-lspconfig').setup({
         -- LSPs to configure is defined in lspconfig's nvim_lspconfig.lua.
         -- List available as ":LspInstall xxx"
         ensure_installed = {
            "ruff",
            "pylsp",
            "vimls",
            "terraformls",
            "rust_analyzer",
            "marksman",
            "lua_ls",
            "ltex",
            "jsonls",
            "yamlls",
            "html",
            "dockerls",
            "astro",
            'harper_ls',
            'copilot',
            'bashls',
         },
         -- For INSTALLED LSPs, automatically enabled LSPs (via vim.lsp.enable(...))
         automatic_enable = true
    })
end

return {config = config}
