local function config()
    -- NOTE: Completion mapping documented at :h ins-completion

    -- A comma-separated list of options for Insert mode completion
    vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

    -- For a list of support completion plugins, 
    -- see https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
    local cmp = require('cmp')
    cmp.setup(
        {
            sources = {
                { name = 'nvim_lsp', keyword_length = 1 },
                { name = 'buffer'},
                { name = 'path'},
                { name = 'bufname'},
                { name = 'buffer-lines', option = {
                    leading_whitespace = true
                }},
                { name = 'nvim_lsp_signature_help'},
                { name = 'calc'},
                { name = 'rpncalc'},
                { name = 'dictionary', keyword_length = 2},
                { name = 'omni', option = {
                    disable_omnifuncs = {'v:lua.vim.lsp.omnifunc'}
                }},
                { name = 'spell', option = {
                    keep_all_entries = false, 
                    enable_in_context = function()
                        return true
                    end,
                    preselect_correc_word = true
                }}
            }
        }
    )
    -- setup completion for '/' and '?' search 
    cmp.setup.cmdline(
        { '/', '?' },
        {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources(
                {
                    -- offers completion based on current buffer's words
                    { 
                        name = 'buffer',
                        option = { keyword_pattern = [[\k\+]] } -- recognize words
                    }
                },
                {
                    -- offers completion based on current buffer's lines unless words source is available
                    {   
                        name = "buffer-lines" 
                    }
                }
            ) 
        }
    )
    -- setup completion for command mode
    cmp.setup.cmdline(
        {':'},
        {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                    -- offers completion based on paths
                    { 
                        name = 'path'
                    },
                    -- offers completion based on cmdline
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
            }
        }
    )
    -- View cmp sources status with :CmpStatus
end

return {config = config}
