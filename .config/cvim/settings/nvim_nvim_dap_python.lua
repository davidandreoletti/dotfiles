local function config()
    -- Full machinery
    -- ┌────────┐ DAP   ┌─────────────┐  ┌────────┐   ┌─────────┐
    -- │dev-tool│──────►│debug-adapter│─►│debugger│──►│ script  │
    -- │  nvim  │       │   debugpy   │  │ pydevd │   │myfile.py│
    -- │nvim-dap│       │             │  │        │   │         │
    -- └────────┘       └─────────────┘  └────────┘   └─────────┘
    --
    -- GOAL: nvim-dap-python configures the generic DAP client (nvim-dap) to use a yielding:
    --  - python -m debugpy --listen localhost:5678 --wait-for-client myfile.py
    -- 
    -- Usually you’d use nvim-dap to set some breakpoints and then start a debug session via :DapNew 
    -- or require("dap").continue(). These commands prompt you for a application-debug-configuration 
    -- declared in a .vscode/launch.json file or within a dap.configurations.<filetype> table 

    -- Assume python is available on $PATH
    require("dap-python").setup("python3")

    -- FIXME: Document how to use .vscode/launch.json to launch project. 
    --        https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#custom-configuration

    -- FIXME  Finish configuring https://www.johntobin.ie/blog/debugging_in_neovim_with_nvim-dap/
end

return {config = config}
