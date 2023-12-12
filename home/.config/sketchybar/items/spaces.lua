local colors = require "colors"
local icons = require "colors"
local helpers = require "helpers"

local function mouse_click(env)
    if env.BUTTON == "right" then
        helpers.hammerspoon(string.format("hs.spaces.removeSpace(%s)", env.SID))
    else
        helpers.hammerspoon(string.format("hs.wm.focus_space(%s)", env.SID))
    end
end

local function space_selection(env)
    local color = env.SELECTED == "true" and colors.grey or colors.bg2

    sbar.set(env.NAME, {
        icon = { highlight = env.SELECTED },
        label = { highlight = env.SELECTED },
        background = { border_color = color },
    })
end

for i = 1, 10, 1 do
    local space = sbar.add("space", "space." .. tostring(i), {
        associated_space = i,
        icon = {
            string = i,
            padding_left = 10,
            padding_right = 10,
            highlight_color = colors.red,
        },
        padding_left = 2,
        padding_right = 2,
        label = {
            padding_right = 10,
            color = colors.grey,
            highlight_color = colors.white,
            font = "sketchybar-app-font:Regular:16.0",
            y_offset = -1,
            drawing = false,
        },
        background = {
            color = colors.bg1,
            border_color = colors.bg2,
        },
        y_offset = -3,
    })

    space:subscribe("space_change", space_selection)
    space:subscribe("mouse.clicked", mouse_click)
end

local space_creator = sbar.add("item", "space.creator", {
    padding_left = 10,
    padding_right = 8,
    icon = {
        string = icons.space,
        font = {
            style = "Heavy",
            size = 16.0,
        },
    },
    label = { drawing = false },
    associated_display = "active",
    y_offset = -3,
})

space_creator:subscribe("mouse.clicked", function(_)
    helpers.hammerspoon "hs.spaces.addSpaceToScreen(hs.screen.mainScreen(), true)"
end)
space_creator:subscribe("space_windows_change", function(env)
    require("app_mapping").draw(env.INFO)
end)

space_selection { ["SELECTED"] = true, ["NAME"] = "space.1" }
