local colors = require "colors"
local module = {}

-- Equivalent to the --bar domain
module.bar = sbar.bar {
    corner_radius = 11,
    height = 45,
    color = colors.bar.bg,
    border_color = colors.bar.border,
    border_width = 1,
    shadow = true,
    sticky = true,
    padding_right = 10,
    padding_left = 10,
    blur_radius = 20,
    y_offset = -8,
    margin = 6,
    topmost = "window",
}

return module
