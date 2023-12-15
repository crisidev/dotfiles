local colors = require "colors"
local module = {}

-- Equivalent to the --default domain
module.default = sbar.default {
    updates = "when_shown",
    icon = {
        font = {
            family = "SF Pro",
            style = "Bold",
            size = 14.0,
        },
        color = colors.icon,
        padding_left = 3,
        padding_right = 3,
    },
    label = {
        font = {
            family = "SF Pro",
            style = "Semibold",
            size = 13.0,
        },
        color = colors.label,
        padding_left = 3,
        padding_right = 3,
    },
    background = {
        height = 26,
        corner_radius = 9,
        border_width = 2,
    },
    popup = {
        background = {
            border_width = 1,
            corner_radius = 10,
            border_color = colors.popup.border,
            color = colors.popup.bg,
            shadow = { drawing = true },
        },
        blur_radius = 20,
    },
    scroll_texts = true,
    padding_left = 3,
    padding_right = 3,
}

return module
