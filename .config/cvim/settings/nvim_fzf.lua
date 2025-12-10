local function config()
    -- Use fzf-vim profile
    --require("fzf-lua").setup({"fzf-vim"})
    require("fzf-lua").setup()
end

return {config = config}
