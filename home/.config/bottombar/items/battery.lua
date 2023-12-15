local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"
local module = {}

module.battery = sbar.add("item", "battery", {
    position = "right",
    icon = {
        string = icons.battery._0,
        font = {
            style = "Regular",
            size = "19.0",
        },
    },
    padding_right = -2,
    update_freq = 120,
    updates = true,
    popup = {
        height = 35,
        align = "right",
    },
    y_offset = 1,
})

module.update = function()
    local battery_info = helpers.runcmd "pmset -g batt"
    local color = colors.red
    local icon = icons.battery._0
    if battery_info then
        local percentage_str = battery_info:match "[0-9]+%%"
        local time = battery_info:match "[0-9]+:[0-9]+ "
        local charging = battery_info:match "AC Power"
        if percentage_str == "" then
            return
        end
        local p = percentage_str:gsub("%%", "")
        local percentage = tonumber(p)
        if percentage > 90 and percentage <= 100 then
            icon = icons.battery._100
            color = colors.white
        elseif percentage > 60 and percentage <= 99 then
            color = colors.white
            icon = icons.battery._75
        elseif percentage > 30 and percentage <= 60 then
            color = colors.yellow
            icon = icons.battery._50
        elseif percentage > 10 and percentage <= 30 then
            color = colors.orange
            icon = icons.battery._30
        else
            color = colors.red
            icon = icons.battery._0
        end

        if charging then
            icon = icons.battery._charging
            color = colors.white
        end

        local label = string.format("Charge %s%%", percentage)
        if time ~= "" then
            label = string.format("%s, remaining time %s", label, time)
        end
        os.execute "bottombar -m --remove 'battery.info'"
        sbar.add("item", "battery.info", {
            position = "popup." .. module.battery.name,
            padding_left = 8,
            padding_right = 15,
            label = label,
        })
    end
    sbar.animate("sin", 10, function()
        module.battery:set { icon = { string = icon, color = color } }
    end)
end

module.battery:subscribe("force", module.update)
module.battery:subscribe("routine", module.update)
module.battery:subscribe("power_source_change", module.update)

module.battery:subscribe("mouse.clicked", function()
    module.battery:set { popup = { drawing = "toggle" } }
end)
module.battery:subscribe("mouse.exited", function()
    module.battery:set { popup = { drawing = "off" } }
end)

return module
