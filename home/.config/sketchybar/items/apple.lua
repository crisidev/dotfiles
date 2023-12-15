local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"

local apple_logo = sbar.add("item", "apple_logo", {
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

local preferences = sbar.add("item", {
    position = "popup." .. apple_logo.name,
    icon = icons.preferences,
    label = "Preferences",
})
preferences:subscribe("mouse.clicked", function(_)
    os.execute "open -a 'System Preferences'"
    apple_logo:set { popup = { drawing = false } }
end)

local activity = sbar.add("item", {
    position = "popup." .. apple_logo.name,
    icon = icons.preferences,
    label = "Activity",
})
activity:subscribe("mouse.clicked", function(_)
    os.execute "open -a 'Activity Monitor'"
    apple_logo:set { popup = { drawing = false } }
end)

local lock = sbar.add("item", {
    position = "popup." .. apple_logo.name,
    icon = icons.preferences,
    label = "Lock Screen",
})
lock:subscribe("mouse.clicked", function(_)
    os.execute "pmset displaysleepnow"
    apple_logo:set { popup = { drawing = false } }
end)

apple_logo:subscribe("mouse.clicked", function(_)
    apple_logo:set { popup = { drawing = "toggle" } }
end)
apple_logo:subscribe("mouse.exited.global", function(_)
    apple_logo:set { popup = { drawing = false } }
end)

-- Forward window_focus to the bottombar
apple_logo:subscribe("window_focus", function(_)
    helpers.window_focus()
end)
helpers.window_focus()
