local colors = require "colors"

-- Equivalent to the --bar domain
sbar.bar {
    corner_radius = 11,
    height = 45,
    color = colors.bar.bg,
    border_width = 2,
    border_color = colors.bar.border,
    shadow = true,
    sticky = true,
    position = "bottom",
    padding_right = 10,
    padding_left = 10,
    blur_radius = 20,
    y_offset = -3,
    margin = 6,
    topmost = "window",
}
