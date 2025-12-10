local function config()
    -- FIXME: Continue setup based on 
    --  - https://tamerlan.dev/a-guide-to-debugging-applications-in-neovim/
    --  - https://www.johntobin.ie/blog/debugging_in_neovim_with_nvim-dap/
    --  - https://dhruvasagar.dev/posts/neovim-java-ide/
    --  - https://github.com/theHamsta/nvim-dap-virtual-text
    --  - https://www.lazyvim.org/extras/dap/core
    --  - https://github.com/rcarriga/nvim-dap-ui?tab=readme-ov-file
    require("dap")

    -- setup DAP config using VSCode launch.json file
    local vscode = require("dap.ext.vscode")
    local json = require("plenary.json")
    vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str))
    end
end

return {config = config}
