local function config()
    -- Setup mason-nvim-dap based on ':h masson-nvim-dap 
    require('mason-nvim-dap').setup({
         -- WARNING: handlers line is required for automatic installation to work
         handlers = {},
         ensure_installed = {
            'bash', -- See https://github.com/jay-babu/mason-nvim-dap.nvim/blob/9a10e096703966335bd5c46c8c875d5b0690dade/lua/mason-nvim-dap/mappings/source.lua#L17
            'python'
         },
         automatic_installation = {
            -- These will be configured by separate plugins
            exclude = {
                'python'
            },
        }
    })
end

return {config = config}
