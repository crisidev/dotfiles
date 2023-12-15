local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"
local module = {}

module.volume_slider = sbar.add("slider", "volume", {
    position = "right",
    updates = true,
    label = {
        drawing = false,
    },
    icon = {
        drawing = false,
    },
    slider = {
        highlight_color = colors.blue,

        background = {
            height = 5,
            corner_radius = 3,
            color = colors.bg2,
        },
        knob = {
            string = icons.knob,
            drawing = true,
        },
    },
    popup = {
        align = "right",
    },
    y_offset = 1,
})

module.volume_icon = sbar.add("item", "volume_icon", {
    position = "right",
    padding_left = 10,
    icon = {
        string = icons.volume._100,
        width = 0,
        align = "left",
        color = colors.white,
        font = {
            style = "Regular",
            size = 15.0,
        },
    },
    label = {
        width = 25,
        align = "left",
        font = {
            style = "Regular",
            size = 15.0,
        },
    },
    y_offset = 1,
})

local function update_devices(env)
    os.execute "bottombar --remove '/volume.device.*/'"
    module.volume_slider:set { popup = { drawing = "toggle" } }
    local current = helpers.runcmd("SwitchAudioSource -t output -c", true)
    local devices = helpers.runcmd "SwitchAudioSource -a -t output"
    if devices then
        local idx = 0
        for device in devices:gmatch "[^\r\n]+" do
            local color = colors.grey
            if device == current then
                color = colors.white
            end
            local click_script = string.format(
                "SwitchAudioSource -s \"%s\" && bottombar --set '/volume.device.*/' label.color=%s --set %s label.color=%s --set %s popup.drawing=off",
                device,
                colors.grey,
                "volume.device." .. tostring(idx),
                colors.white,
                env.NAME
            )
            sbar.add("item", "volume.device." .. tostring(idx), {
                position = "popup." .. module.volume_slider.name,
                label = {
                    string = device .. "    ",
                    color = color,
                },
                padding_left = 8,
                padding_right = 15,
                click_script = click_script,
            })
            idx = idx + 1
        end
    end
end

module.volume_slider:subscribe("volume_change", function(env)
    local percentage = tonumber(env.INFO)
    local icon = icons.volume._0
    if percentage > 90 and percentage <= 100 then
        icon = icons.volume._100
    elseif percentage > 60 and percentage <= 99 then
        icon = icons.volume._66
    elseif percentage > 30 and percentage <= 60 then
        icon = icons.volume._33
    elseif percentage > 10 and percentage <= 30 then
        icon = icons.volume._10
    else
        icon = icons.volume._0
    end
    module.volume_icon:set { label = icon }
    module.volume_slider:set { slider = { percentage = percentage } }
    local info = sbar.query(env.NAME)
    if info and info["slider"] and tonumber(info.slider.width) == 0 then
        helpers.slider_on(module.volume_slider, "sin", 20)
    end

    os.execute "sleep 1"

    info = sbar.query(env.NAME)
    if info and info["slider"] and info.slider.percentage == env.INFO then
        helpers.slider_off(module.volume_slider, "sin", 20)
    end
end)

module.volume_slider:subscribe("mouse.clicked", function(env)
    os.execute('osascript -e "set volume output volume ' .. env.PERCENTAGE .. '"')
end)

module.volume_slider:subscribe("mouse.exited", function(env)
    helpers.slider_off(module.volume_slider, "sin", 20)
end)

module.volume_icon:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "right" or env.MODIFIER == "shift" then
        update_devices()
    else
        local info = sbar.query "volume"
        if info and info["slider"] and tonumber(info.slider.width) == 0 then
            helpers.slider_on(module.volume_slider, "sin", 20)
        else
            helpers.slider_off(module.volume_slider, "sin", 20)
        end
    end
end)

module.volume_icon:subscribe("mouse.exited.global", function()
    module.volume_slider:set { popup = { drawing = "off" } }
end)

return module
