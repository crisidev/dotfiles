local M = {}

M.config = function()
    local status_ok, sig = pcall(require, "lsp_signature")
    if not status_ok then
        return
    end
    local icons = require("user.icons").icons

    local opts = {
        bind = true,
        doc_lines = 10,
        floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
        floating_window_above_cur_line = true,
        fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
        hint_enable = true, -- virtual hint enable
        hint_prefix = icons.Function .. " ",
        hint_scheme = "String",
        hi_parameter = "SpecialComment", -- how your parameter will be highlight
        max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
        -- to view the hiding contents
        max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
        handler_opts = {
            border = "rounded", -- double, single, shadow, none
        },
        -- transpancy = 80,
        -- extra_trigger_chars = { "(", "," }, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
        zindex = 1002, -- by default it will be on top of all floating windows, set to 50 send it to bottom
        debug = false, -- set to true to enable debug logging
        log_path = "debug_log_file_path", -- debug log path
        padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
        shadow_blend = 36, -- if you using shadow as border use this set the opacity
        shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
        noice = true,
        floating_window_off_x = 5, -- adjust float windows x position.
        floating_window_off_y = function() -- adjust float windows y position. e.g. set to -2 can make floating window move up 2 lines
            local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buf line number
            local pumheight = vim.o.pumheight
            local winline = vim.fn.winline() -- line number in the window
            local winheight = vim.fn.winheight(0)

            -- window top
            if winline - 1 < pumheight then
                return pumheight
            end

            -- window bottom
            if winheight - winline < pumheight then
                return -pumheight
            end
            return 0
        end,
    }
    sig.setup(opts)
end

return M
