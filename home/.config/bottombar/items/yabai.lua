local helpers = require "helpers"
local colors = require "colors"
local icons = require "icons"

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

local function yabai_mode()
    local windows = helpers.runcmd "yabai -m query --windows --space"
    local space = helpers.runcmd "yabai -m query --spaces --space"
    if windows and type(windows) == "table" and space and type(space) == "table" then
        for _, window in pairs(windows) do
            if window["is-floating"] then
                if window["app"] == "kitty" then
                    return "float-term", icons.yabai.float, colors.yellow
                else
                    return "float", icons.yabai.float, colors.yellow
                end
            elseif window["has-fullscreen-zoom"] or window["has-parent-zoom"] then
                return "fullscreen", icons.yabai.fullscreen_zoom, colors.orange
            end
        end
        local space_mode = space["type"]
        if space_mode == "stack" then
            return "stack", icons.yabai.stack, colors.red
        elseif space_mode == "float" then
            return "float", icons.yabai.float, colors.yellow
        else
            return "bsp", icons.yabai.grid, colors.blue
        end
    end
end

local function window_focus()
    local mode, icon, color = yabai_mode()
    sbar.animate("tanh", 10, function()
        yabai:set { icon = { string = icon, color = color, width = 28 } }
    end)
    os.execute("sketchybar --animate than 10 --set apple_logo icon.color=" .. color)
    if mode == "stack" then
        os.execute 'borders active_color="glow(0xffed8796)" inactive_color="glow(0xff414550)"'
    elseif mode == "float" then
        os.execute 'borders active_color=0x00000000 inactive_color="glow(0xff414550)"'
    elseif mode == "float-term" then
        os.execute 'borders active_color="glow(0xffeed49f)" inactive_color="glow(0xff414550)"'
    elseif mode == "fullscreen" then
        os.execute 'borders active_color="glow(0xfff5a97f)" inactive_color="glow(0xff414550)"'
    else
        os.execute 'borders active_color="glow(0xff95b5ff)" inactive_color="glow(0xff414550)"'
    end
end

yabai:subscribe("mouse.clicked", function()
    helpers.runcmd "yabai -m window --toggle float"
    window_focus()
end)

yabai:subscribe("window_focus", function()
    window_focus()
end)

window_focus()
