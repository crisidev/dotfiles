local module = {}

module.cpu = sbar.add("alias", "Stats,CPU", {
    position = "right",
    padding_right = 0,
    padding_left = -10,
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
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
module.gpu:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

module.ram = sbar.add("alias", "Stats,RAM_line_chart", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
module.ram:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

module.network_speed = sbar.add("alias", "Stats,Network_speed", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
module.network_speed:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

module.network_label = sbar.add("alias", "Stats,Network_label", {
    position = "right",
    padding_right = -10,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
module.network_label:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

module.disk_speed = sbar.add("alias", "Stats,Disk_speed", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
module.disk_speed:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

module.disk_bar_chart = sbar.add("alias", "Stats,Disk_bar_chart", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
module.disk_bar_chart:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

module.sensors = sbar.add("alias", "Stats,Sensors_sensors", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
module.sensors:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

module.sensors_label = sbar.add("alias", "Stats,Sensors_label", {
    position = "right",
    padding_right = -15,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
module.sensors_label:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

module.tailscale = sbar.add("alias", "Tailscale,Item-0", {
    position = "right",
    padding_right = -5,
    padding_left = -5,
    label = {
        width = 0,
    },
    y_offset = -3,
})

return module
