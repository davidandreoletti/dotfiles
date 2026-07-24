if vim.fn.has('nvim') == 1 then
    vim.keymap.set( {'n'}, '<leader>?',
        function() require('which-key').show({global = false}) end,
        { desc = 'Buffer local keymap (which-key)', }
    )
end
