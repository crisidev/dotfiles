local helpers = require "helpers"
local colors = require "colors"
local icons = require "icons"
local module = {}

module.yabai = sbar.add("item", "yabai", {
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

local function update_borders(mode)
    if mode == "stack" then
        os.execute(
            string.format(
                'borders active_color="glow(%s)" inactive_color="glow(%s)"',
                colors.red_str,
                colors.inactive_border_str
            )
        )
    elseif mode == "float" then
        os.execute(
            string.format(
                'borders active_color="%s" inactive_color="glow(%s)"',
                colors.transparent_str,
                colors.inactive_border_str
            )
        )
    elseif mode == "float-term" then
        os.execute(
            string.format(
                'borders active_color="glow(%s)" inactive_color="glow(%s)"',
                colors.yellow_str,
                colors.inactive_border_str
            )
        )
    elseif mode == "fullscreen" then
        os.execute(
            string.format(
                'borders active_color="glow(0xfff5a97f)" inactive_color="glow(%s)"',
                colors.orange_str,
                colors.inactive_border_str
            )
        )
    else
        os.execute(
            string.format(
                'borders active_color="glow(%s)" inactive_color="glow(%s)"',
                colors.active_border_str,
                colors.inactive_border_str
            )
        )
    end
end

local function window_focus()
    local mode, icon, color = yabai_mode()
    update_borders(mode)
    sbar.animate("tanh", 10, function()
        module.yabai:set { icon = { string = icon, color = color, width = 28 } }
    end)
    os.execute("sketchybar --animate than 10 --set apple_logo icon.color=" .. color)
end

module.subscribe_system_woke = function(args)
    window_focus()
    module.yabai:subscribe("system_woke", function()
        for _, component in pairs(args) do
            component.update()
        end
    end)
end

module.yabai:subscribe("window_focus", window_focus)

module.yabai:subscribe("mouse.clicked", function()
    helpers.runcmd "yabai -m window --toggle float"
    window_focus()
end)


return module
