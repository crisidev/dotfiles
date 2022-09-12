local M = {}

M.config = function()
    local status_ok, todo = pcall(require, "todo-comments")
    if not status_ok then
        return
    end
    local icons = require("user.icons").todo_comments
    todo.setup {
        keywords = {
            FIX = { icon = icons.FIX, "FIXME", "BUG", "FIXIT", "ISSUE" },
            TODO = { icon = icons.TODO, alt = { "WIP" } },
            HACK = { icon = icons.HACK, color = "hack" },
            WARN = { icon = icons.WARN, alt = { "WARNING", "XXX" } },
            PERF = { icon = icons.PERF, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = icons.NOTE, alt = { "INFO", "NB" } },
            ERROR = { icon = icons.ERROR, color = "error", alt = { "ERR" } },
            REFS = { icon = icons.REFS },
            TEST = { icon = icons.TEST, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        highlight = { max_line_len = 120 },
        colors = {
            error = { "DiagnosticError" },
            warning = { "DiagnosticWarn" },
            info = { "DiagnosticInfo" },
            hint = { "DiagnosticHint" },
            hack = { "Function" },
            ref = { "FloatBorder" },
            default = { "Identifier" },
        },
    }
    -- TODO: some
end

return M
