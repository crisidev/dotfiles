local helpers = require "helpers"

local yabai = sbar.add("item", "yabai", {
    icon = {
        width = 0,
        font = {
            style = "Bold",
            size = 16.0,
        },
    },
    label = {
        width = 0,
    },
    popup = {
        height = 35,
    },
})

local function window_focus()
    local icon, color = helpers.yabai_mode()
    sbar.animate("tanh", 10, function()
        yabai:set { icon = { string = icon, color = color, width = 28 } }
    end)
end

yabai:subscribe("mouse.clicked", function()
    helpers.runcmd "yabai -m window --toggle float"
    window_focus()
end)

yabai:subscribe("window_focus", function()
    window_focus()
end)

window_focus()
