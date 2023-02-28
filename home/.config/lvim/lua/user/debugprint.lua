local M = {}

M.config = function()
    local debugprint = require "debugprint"
    vim.keymap.set("n", "f?b", function()
        return debugprint.debugprint()
    end, {
        expr = true,
        desc = "Plain debug below current line",
    })
    vim.keymap.set("n", "f?a", function()
        return debugprint.debugprint { above = true }
    end, {
        expr = true,
        desc = "Plain debug above current line",
    })
    vim.keymap.set("n", "f?B", function()
        return debugprint.debugprint { variable = true }
    end, {
        expr = true,
        desc = "Variable debug below current line",
    })
    vim.keymap.set("n", "f?A", function()
        return debugprint.debugprint { above = true, variable = true }
    end, {
        expr = true,
        desc = "Variable debug above current line",
    })
    vim.keymap.set("x", "f?b", function()
        return debugprint.debugprint { variable = true }
    end, {
        expr = true,
        desc = "Visually-selected variable debug below current line",
    })
    vim.keymap.set("x", "f?a", function()
        return debugprint.debugprint { above = true, variable = true }
    end, {
        expr = true,
        desc = "Visually-selected variable debug above current line",
    })
    vim.keymap.set("n", "f?o", function()
        return debugprint.debugprint { motion = true }
    end, {
        expr = true,
        desc = "Text-obj-selected variable debug below current line",
    })
    vim.keymap.set("n", "f?O", function()
        return debugprint.debugprint { motion = true, above = true }
    end, {
        expr = true,
        desc = "Text-obj-selected variable debug above current line",
    })
end

return M
