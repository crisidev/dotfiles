local M = {}

M.config = function()
    local status_ok, fidget = pcall(require, "fidget")
    if not status_ok then
        return
    end
    local relative = "editor"
    if lvim.builtin.global_statusline.active then
        relative = "win"
    end

    fidget.setup {
        text = {
            spinner = {
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
            },
            done = "✔", -- character shown when all tasks are complete
            -- commenced = "Started", -- message shown when task starts
            -- completed = "Completed", -- message shown when task completes
            commenced = "", -- message shown when task starts
            completed = " ", -- message shown when task completes
        },
        align = {
            bottom = true, -- align fidgets along bottom edge of buffer
            right = true, -- align fidgets along right edge of buffer
        },
        timer = {
            spinner_rate = 100, -- frame rate of spinner animation, in ms
            fidget_decay = 1500, -- how long to keep around empty fidget, in ms
            task_decay = 500, -- how long to keep around completed task, in ms
        },
        window = {
            relative = relative, -- where to anchor the window, either `"win"` or `"editor"`
            blend = 0, -- `&winblend` for the window
            zindex = nil, -- the `zindex` value for the window
        },
        fmt = {
            leftpad = true, -- right-justify text in fidget box
            stack_upwards = true, -- list of tasks grows upwards
            max_width = 0,
            -- function to format fidget title
            fidget = function(fidget_name, spinner)
                return string.format("%s %s", spinner, fidget_name)
            end,
            -- function to format each task line
            task = function(task_name, message, percentage)
                return string.format(
                    "%s%s [%s]",
                    message,
                    percentage and string.format(" (%s%%)", percentage) or "",
                    task_name
                )
            end,
        },
        debug = {
            logging = false, -- whether to enable logging, for debugging
            strict = false,
        },
    }
end

return M
