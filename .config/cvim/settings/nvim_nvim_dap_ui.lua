local function config()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Configure DAP UI
    require('dapui').setup()

    -- Open/Close DAP UI when attaching/launching/terminating/exiting debug session
    dap.listeners.before.attach.dapui_config = function()
        dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
        dapui.open()
    end
    dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
        --dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
        --dapui.close()
    end
end

return {config = config}
