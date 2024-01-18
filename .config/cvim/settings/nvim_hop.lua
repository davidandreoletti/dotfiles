local function config()
    -- Setup hop
    require('hop').setup({
        -- characters to use as hint for Dvorack users
        keys = 'aoeuidtnsqjkxbhwvzpyfg',
        -- leave hop mode
        quit_key = '<ESC>',
        -- Jump on sole occurence
        jump_on_sole_occurrence = false,
        case_insensitive = false,
        -- Hint every windows visible on the terminal
        multi_windows = true,
    })

    -- Same mapping as vim-easymotion 
    vim.api.nvim_set_keymap("n", "<Leader><Leader>s", "<cmd>HopChar1<CR>", {noremap=true})
    -- normal mode (easymotion-like)
    vim.api.nvim_set_keymap("n", "<Leader><Leader>b", "<cmd>HopWordBC<CR>", {noremap=true})
    vim.api.nvim_set_keymap("n", "<Leader><Leader>w", "<cmd>HopWordAC<CR>", {noremap=true})
    vim.api.nvim_set_keymap("n", "<Leader><Leader>j", "<cmd>HopLineAC<CR>", {noremap=true})
    vim.api.nvim_set_keymap("n", "<Leader><Leader>k", "<cmd>HopLineBC<CR>", {noremap=true})
    -- visual mode (easymotion-like)
    vim.api.nvim_set_keymap("v", "<Leader><Leader>w", "<cmd>HopWordAC<CR>", {noremap=true})
    vim.api.nvim_set_keymap("v", "<Leader><Leader>b", "<cmd>HopWordBC<CR>", {noremap=true})
    vim.api.nvim_set_keymap("v", "<Leader><Leader>j", "<cmd>HopLineAC<CR>", {noremap=true})
    vim.api.nvim_set_keymap("v", "<Leader><Leader>k", "<cmd>HopLineBC<CR>", {noremap=true})
end

return {config = config}

