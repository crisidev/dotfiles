local colors = require "colors"
local helpers = require "helpers"
local module = {}

module.cpu = sbar.add("alias", "Stats,CPU", {
    position = "right",
    padding_left = -20,
    label = {
        width = 0,
    },
    y_offset = -3,
})
module.cpu:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

module.gpu = sbar.add("alias", "Stats,GPU_bar_chart", {
    position = "right",
    padding_left = -16,
    label = {
        width = 0,
    },
    y_offset = -3,
})

module.ram = sbar.add("alias", "Stats,RAM_line_chart", {
    position = "right",
    padding_left = -16,
    label = {
        width = 0,
    },
    y_offset = -3,
})

module.network_speed = sbar.add("alias", "Stats,Network_speed", {
    position = "right",
    padding_left = -20,
    label = {
        width = 0,
    },
    y_offset = -3,
})

module.network_label = sbar.add("alias", "Stats,Network_label", {
    position = "right",
    padding_left = -22,
    label = {
        width = 0,
    },
    y_offset = -3,
})

module.disk_speed = sbar.add("alias", "Stats,Disk_speed", {
    position = "right",
    padding_right = 10,
    padding_left = -20,
    label = {
        width = 0,
    },
    y_offset = -3,
})

module.disk_bar_chart = sbar.add("alias", "Stats,Disk_bar_chart", {
    position = "right",
    padding_left = -20,
    label = {
        width = 0,
    },
    y_offset = -3,
})

module.sensors = sbar.add("alias", "Stats,Sensors_sensors", {
    position = "right",
    padding_left = -27,
    label = {
        width = 0,
    },
    y_offset = -3,
})

module.sensors_label = sbar.add("alias", "Stats,Sensors_label", {
    position = "right",
    padding_left = -20,
    label = {
        width = 0,
    },
    y_offset = -3,
})

module.tailscale = sbar.add("alias", "Tailscale,Item-0", {
    position = "right",
    padding_left = -5,
    label = {
        width = 0,
    },
    popup = {
        align = "right",
    },
    y_offset = -3,
})
module.tailscale:subscribe("mouse.clicked", function()
    os.execute "sketchybar -m --remove '/tailscale.info.*/'"
    local tailscale_nets = helpers.runcmd("/Applications/Tailscale.app/Contents/MacOS/Tailscale switch --list")
    if tailscale_nets then
        local idx = 1
        for profile in tailscale_nets:gmatch "[^\r\n]+" do
            if not profile:match "^ID.*$" then
                local color = colors.grey
                if profile:match "^.**$" then
                    color = colors.white
                end
                sbar.add("item", "tailscale.info." .. idx, {
                    position = "popup." .. module.tailscale.name,
                    label = { string = profile, color = color },
                })
            end
            idx = idx + 1
        end
        module.tailscale:set { popup = { drawing = "toggle" } }
    end
end)
module.tailscale:subscribe("mouse.exited.global", function()
    module.tailscale:set { popup = { drawing = false } }
end)

module.stats = sbar.add("bracket", "stats", {
    module.cpu.name,
    module.gpu.name,
    module.ram.name,
    module.network_speed.name,
    module.network_label.name,
    module.disk_speed.name,
    module.disk_bar_chart.name,
    module.sensors.name,
    module.sensors_label.name,
    module.tailscale.name,
}, {
    position = "right",
    background = {
        color = colors.bg1,
        border_color = colors.bg2,
        height = 28,
    },
    y_offset = -3,
})

return module
