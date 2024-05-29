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
    sbar.exec 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
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
    padding_left = -10,
    label = {
        width = 0,
    },
    popup = {
        align = "right",
    },
    y_offset = -3,
})
module.zscaler = sbar.add("alias", "Zscaler,Item-0", {
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
    module.zscaler.name,
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
