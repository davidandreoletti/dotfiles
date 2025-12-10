-- Diagostics. See `:help diagnostic-defaults
-- Show diagnostics in a floating window
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
-- Show diagnostics in a bottom window
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
-- Jump to the previous diagnostic
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- Jump to the next diagnostic
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
