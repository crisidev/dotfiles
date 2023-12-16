local colors = require "colors"

sbar.add("bracket", "status", {
    "brew",
    "notify",
    "wifi",
    "battery",
    "volume_icon",
    "mic_icon",
}, {
    background = {
        color = colors.bg1,
        border_color = colors.bg2,
        height = 33,
    },
})
