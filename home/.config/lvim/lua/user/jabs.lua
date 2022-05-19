-- (Optional) easy way to get Neovim current size.
local M = {}

local ui = vim.api.nvim_list_uis()[1]

M.config = function()
    require("jabs").setup {
        position = "corner", -- center, corner
        width = ui.width,
        height = 10,
        border = "none", -- none, single, double, rounded, solid, shadow, (or an array or chars)

        -- Options for preview window
        preview_position = "left", -- top, bottom, left, right
        preview = {
            width = 40,
            height = 30,
            border = "double", -- none, single, double, rounded, solid, shadow, (or an array or chars)
        },

        -- the options below are ignored when position = 'center'
        col = ui.width, -- Window appears on the right
        row = ui.height / 2, -- Window appears in the vertical middle
    }
end

return M
