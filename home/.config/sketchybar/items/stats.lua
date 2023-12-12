local cpu = sbar.add("alias", "Stats,CPU", {
    position = "right",
    padding_right = 0,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
cpu:subscribe("mouse.clicked", function()
    os.execute 'open -a "/System/Applications/Utilities/Activity Monitor.app"'
end)

sbar.add("alias", "Stats,GPU_bar_chart", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})

sbar.add("alias", "Stats,RAM_line_chart", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})

sbar.add("alias", "Stats,Network_speed", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
sbar.add("alias", "Stats,Network_label", {
    position = "right",
    padding_right = -10,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})

sbar.add("alias", "Stats,Disk_speed", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
sbar.add("alias", "Stats,Disk_bar_chart", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})

sbar.add("alias", "Stats,Sensors_sensors", {
    position = "right",
    padding_right = -5,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})
sbar.add("alias", "Stats,Sensors_label", {
    position = "right",
    padding_right = -15,
    padding_left = -10,
    label = {
        width = 0,
    },
    y_offset = -3,
})

sbar.add("alias", "Tailscale,Item-0", {
    position = "right",
    padding_right = -5,
    padding_left = -5,
    label = {
        width = 0,
    },
    y_offset = -3,
})
