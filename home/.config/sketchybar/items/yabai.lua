local helpers = require "helpers"
local colors = require "colors"
local icons = require "icons"
local homedir = os.getenv "HOME"
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
    padding_left = -3,
    y_offset = -3,
})

module.lock = sbar.add("item", "yabai.lock", {
    position = "popup." .. module.yabai.name,
    padding_left = 10,
    padding_right = 10,
    icon = {
        string = icons.power.lock,
        font = {
            style = "Bold",
            size = 16.0,
        },
    },
    label = "Lock screen",
})

module.lock:subscribe("mouse.clicked", function(_)
    helpers.hammerspoon "hs.caffeinate.lockScreen()"
    module.yabai:set { popup = { drawing = false } }
end)

module.sleep = sbar.add("item", "yabai.sleep", {
    position = "popup." .. module.yabai.name,
    padding_left = 10,
    padding_right = 10,
    icon = {
        string = icons.power.sleep,
        font = {
            style = "Bold",
            size = 16.0,
        },
    },
    label = "Go to sleep",
})

module.sleep:subscribe("mouse.clicked", function(_)
    sbar.exec "sleep 1 && osascript -e 'tell app \"System Events\" to sleep'"
    module.yabai:set { popup = { drawing = false } }
end)

module.restart = sbar.add("item", "yabai.restart", {
    position = "popup." .. module.yabai.name,
    padding_left = 10,
    padding_right = 10,
    icon = {
        string = icons.power.reboot,
        font = {
            style = "Bold",
            size = 16.0,
        },
    },
    label = "Restart system",
})

module.restart:subscribe("mouse.clicked", function(_)
    sbar.exec "sleep 1 && osascript -e 'tell app \"System Events\" to restart'"
    module.yabai:set { popup = { drawing = false } }
end)

module.shutdown = sbar.add("item", "yabai.shutdown", {
    position = "popup." .. module.yabai.name,
    padding_left = 10,
    padding_right = 10,
    icon = {
        string = icons.power.poweroff,
        font = {
            style = "Bold",
            size = 16.0,
        },
    },
    label = "Shutdown system",
})

module.shutdown:subscribe("mouse.clicked", function(_)
    sbar.exec "sleep 1 && osascript -e 'tell app \"System Events\" to shutdown'"
    module.yabai:set { popup = { drawing = false } }
end)

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
        sbar.exec(
            string.format(
                'borders active_color="glow(%s)" inactive_color="glow(%s)"',
                colors.red_str,
                colors.inactive_border_str
            )
        )
    elseif mode == "float" then
        sbar.exec(
            string.format(
                'borders active_color="%s" inactive_color="glow(%s)"',
                colors.transparent_str,
                colors.inactive_border_str
            )
        )
    elseif mode == "float-term" then
        sbar.exec(
            string.format(
                'borders active_color="glow(%s)" inactive_color="glow(%s)"',
                colors.yellow_str,
                colors.inactive_border_str
            )
        )
    elseif mode == "fullscreen" then
        sbar.exec(
            string.format(
                'borders active_color="glow(0xfff5a97f)" inactive_color="glow(%s)"',
                colors.orange_str,
                colors.inactive_border_str
            )
        )
    else
        sbar.exec(
            string.format(
                'borders active_color="glow(%s)" inactive_color="glow(%s)"',
                colors.active_border_str,
                colors.inactive_border_str
            )
        )
    end
end

module.update = function()
    local mode, icon, color = yabai_mode()
    -- update_borders(mode)
    sbar.animate("tanh", 10, function()
        module.yabai:set { icon = { string = icon, color = color, width = 28 } }
    end)
    sbar.exec "bottombar --trigger window_focus"
end

module.subscribe_system_woke = function(args)
    module.update()
    module.yabai:subscribe("system_woke", function()
        for _, component in pairs(args) do
            component.update()
        end
    end)
end

module.yabai:subscribe("window_focus", module.update)

module.yabai:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "right" then
        sbar.exec(homedir .. "/.config/yabai/layout")
        module.update()
    elseif env.BUTTON == "left" then
        module.yabai:set { popup = { drawing = "toggle" } }
    end
end)

module.yabai:subscribe("mouse.exited.global", function(env)
    module.yabai:set { popup = { drawing = false } }
end)

return module
