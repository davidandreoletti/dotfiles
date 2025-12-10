vim.keymap.set( {'n','v'}, '<leader>-',
    "<cmd>Yazi<cr>",
    { desc = 'Open file manager at current file', }
)
vim.keymap.set( {'n','v'}, '<leader>cw',
    "<cmd>Yazi cwd<cr>",
    { desc = 'Open file manager in nvim working directory', }
)
vim.keymap.set( {'n','v'}, '<C-up>',
    "<cmd>Yazi toggle<cr>",
    { desc = 'Resume last file manager session', }
)
