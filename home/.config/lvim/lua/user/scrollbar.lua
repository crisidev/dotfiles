local M = {}

M.config = function()
    local colors = require("tokyonight.colors").setup()

    require("scrollbar").setup {
        handle = {
            color = colors.bg_highlight,
        },
        marks = {
            Search = { color = colors.orange },
            Error = { color = colors.error },
            Warn = { color = colors.warning },
            Info = { color = colors.info },
            Hint = { color = colors.hint },
            Misc = { color = colors.purple },
        },
    }
end

M.register_current_position_handler = function()
    local icons = require("user.icons").icons

    require("scrollbar.handlers").register("current_position", function(bufnr)
        local pos = vim.api.nvim_win_get_cursor(0)

        return {
            { line = pos[1], text = icons.code_lens_action, type = "Misc" },
        }
    end)
end

return M
