-- DAP: Breakpoints
vim.keymap.set( 'n', '<leader>db', function() require('dap').toggle_breakpoint() end,
    { desc = 'Toggle breakpoint', }
)
vim.keymap.set( 'n', '<leader>dB',
    function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
    { desc = 'Breakpoint condition', }
)
vim.keymap.set( 'n', '<leader>dc',
    function() require('dap').continue() end,
    { desc = 'Run/Continue', }
)
vim.keymap.set( 'n', '<leader>dC',
    function() require('dap').run_to_cursor() end,
    { desc = 'Run to cursor', }
)
vim.keymap.set( 'n', '<leader>dg',
    function() require('dap').goto_() end,
    { desc = 'Go to Line (no execute)', }
)
vim.keymap.set( 'n', '<leader>ds',
    function() require('dap').continue() end,
    { desc = 'Continue', }
)
vim.keymap.set( 'n', '<leader>di',
    function() require('dap').step_into() end,
    { desc = 'Step into', }
)
vim.keymap.set( 'n', '<leader>dj',
    function() require('dap').down() end,
    { desc = 'Down', }
)
vim.keymap.set( 'n', '<leader>dk',
    function() require('dap').up() end,
    { desc = 'Up', }
)
vim.keymap.set( 'n', '<leader>dl',
    function() require('dap').run_last() end,
    { desc = 'Run last', }
)
vim.keymap.set( 'n', '<leader>dO',
    function() require('dap').step_over() end,
    { desc = 'Step over', }
)
vim.keymap.set( 'n', '<leader>do',
    function() require('dap').step_out() end,
    { desc = 'Step out', }
)
vim.keymap.set( 'n', '<leader>dP',
    function() require('dap').pause() end,
    { desc = 'Step over', }
)
vim.keymap.set( 'n', '<leader>dr',
    function() require('dap').repl.toggle() end,
    { desc = 'Breakpoint condition', }
)
vim.keymap.set( 'n', '<leader>ds',
    function() require('dap').session() end,
    { desc = 'Session', }
)
vim.keymap.set( 'n', '<leader>dt',
    function() require('dap').terminate() end,
    { desc = 'Terminate', }
)
vim.keymap.set( 'n', '<leader>dw',
    function() require('dap.ui.widgets').hover() end,
    { desc = 'Widgets', }
)
-- DAP UI: Show/Hide
vim.keymap.set( 'n', '<leader>du',
    function() require('dapui').toggle() end,
    { desc = 'Toggle DAP UI', }
)
vim.keymap.set( 'n', '<leader>de',
    function() require('dapui').eval() end,
    { desc = 'DAP evaluate expression (word or highlighted)', }
)
-- DAP-python: Run
vim.keymap.set( 'n', '<leader>dn',
    function() require('dap-python').test_method() require('dapui').open()
    end, { desc = 'Run test method',
    }
)

vim.keymap.set( 'n', '<leader>df',
    function() require('dap-python').test_class() require('dapui').open()
    end, { desc = 'Run test class',
    }
)

-- FIXME: Turn this into :MyFunction
--" Print the configuration for Python.  If this is empty, focus on changing the
--" configuration of nvim-dap-python until you see entries here.
--:lua vim.print(require('dap').configurations.python)
--" Print the configuration for the current filetype.  If this is empty, there is
--" most likely something wrong with the configuration of mason-nvim-dap.nvim.
--" Make sure you check the filetype is included in the list of supported debug
--" adaptors at
--" https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/filetypes.lua
--:lua vim.print(require('dap').configurations[vim.bo.filetype])
