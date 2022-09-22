local M = {}

M.config = function()
    local status_ok, ui = pcall(require, "dapui")
    if not status_ok then
        return
    end
    local icons = require("user.icons").icons

    ui.setup {
        expand_lines = true,
        icons = {
            expanded = icons.expanded,
            collapsed = icons.collapsed,
            circular = icons.circular,
        },
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.33 },
                    { id = "breakpoints", size = 0.17 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 0.25 },
                },
                size = 0.33,
                position = "right",
            },
            {
                elements = { { id = "repl", size = 0.45 }, { id = "console", size = 0.55 } },
                size = 0.27,
                position = "bottom",
            },
        },
        floating = { max_width = 0.9, max_height = 0.5, border = vim.g.border_chars },
    }

    lvim.builtin.dap.on_config_done = function(dap)
        dap.listeners.after.event_initialized["dapui_config"] = function()
            ui.open {}
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            ui.close {}
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            ui.close {}
        end
    end
end

return M
