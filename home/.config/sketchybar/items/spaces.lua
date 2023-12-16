local colors = require "colors"
local icons = require "colors"
local helpers = require "helpers"
local app_mapping = require "app_mapping"
local module = {}
module.spaces = {}

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

local function window_change(input)
    local space = input["space"]
    local apps = input["apps"]
    if space then
        if apps then
            sbar.animate("sin", 10, function()
                module.spaces[space]:set { label = { string = app_mapping.icons(apps), drawing = true } }
            end)
        else
            sbar.animate("sin", 10, function()
                module.spaces[space]:set { label = { drawing = false } }
            end)
        end
    end
end

for i = 1, 10, 1 do
    local space = sbar.add("space", "space." .. tostring(i), {
        associated_space = i,
        icon = {
            string = i,
            padding_left = 10,
            padding_right = 10,
            highlight_color = colors.orange,
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
    module.spaces[i] = space
end

module.space_creator = sbar.add("item", "space.creator", {
    position = "left",
    padding_left = 10,
    padding_right = 8,
    icon = {
        string = icons.space,
        color = colors.white,
        font = {
            style = "Heavy",
            size = 16.0,
        },
    },
    label = { drawing = false },
    associated_display = "active",
    click_script= "~/.bin/hs -c 'hs.spaces.addSpaceToScreen(hs.screen.mainScreen(), true)'",
    y_offset = -3,
})

module.space_creator:subscribe("mouse.clicked", function(_)
end)

module.space_creator:subscribe("space_windows_change", function(env)
    window_change(env.INFO)
end)

module.update = function()
    space_selection { ["SELECTED"] = true, ["NAME"] = "space.1" }
end

return module
