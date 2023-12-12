local settings = require "settings"
local colors = require "colors"

-- Equivalent to the --default domain
sbar.default {
    updates = "when_shown",
    icon = {
        font = {
            family = settings.font,
            style = "Bold",
            size = 14.0,
        },
        color = colors.icon,
        padding_left = settings.paddings,
        padding_right = settings.paddings,
    },
    label = {
        font = {
            family = settings.font,
            style = "Semibold",
            size = 13.0,
        },
        color = colors.label,
        padding_left = settings.paddings,
        padding_right = settings.paddings,
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
    padding_left = settings.paddings,
    padding_right = settings.paddings,
}
