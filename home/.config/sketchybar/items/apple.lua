local icons = require "icons"
local colors = require "colors"
local module = {}

module.apple_logo = sbar.add("item", "apple_logo", {
    padding_right = 10,
    icon = {
        string = icons.apple,
        font = {
            style = "Black",
            size = 18.0,
        },
        color = colors.green,
    },
    label = {
        drawing = false,
    },
    popup = {
        height = 35,
    },
    y_offset = -2,
})

module.subscribe_system_woke = function(args)
    module.apple_logo:subscribe("system_woke", function()
        for _, component in pairs(args) do
            component.update()
        end
    end)
end

local preferences = sbar.add("item", {
    position = "popup." .. module.apple_logo.name,
    icon = icons.preferences,
    label = "Preferences",
})
preferences:subscribe("mouse.clicked", function(_)
    sbar.exec "open -a 'System Preferences'"
    module.apple_logo:set { popup = { drawing = false } }
end)

local activity = sbar.add("item", {
    position = "popup." .. module.apple_logo.name,
    icon = icons.preferences,
    label = "Activity",
})
activity:subscribe("mouse.clicked", function(_)
    sbar.exec "open -a 'Activity Monitor'"
    module.apple_logo:set { popup = { drawing = false } }
end)

local lock = sbar.add("item", {
    position = "popup." .. module.apple_logo.name,
    icon = icons.preferences,
    label = "Lock Screen",
})
lock:subscribe("mouse.clicked", function(_)
    sbar.exec "pmset displaysleepnow"
    module.apple_logo:set { popup = { drawing = false } }
end)

module.apple_logo:subscribe("mouse.clicked", function(_)
    module.apple_logo:set { popup = { drawing = "toggle" } }
end)
module.apple_logo:subscribe("mouse.exited.global", function(_)
    module.apple_logo:set { popup = { drawing = false } }
end)

return module
