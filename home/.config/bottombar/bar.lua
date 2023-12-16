local colors = require "colors"

local module = {}

-- Equivalent to the --bar domain
module.bar = sbar.bar {
    position = "bottom",
    corner_radius = 11,
    height = 45,
    color = colors.bar.bg,
    border_width = 1,
    border_color = colors.bar.border,
    shadow = true,
    sticky = true,
    padding_right = 10,
    padding_left = 10,
    blur_radius = 20,
    y_offset = -3,
    margin = 6,
    topmost = false,
    display = "main",
}

return module
