local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"

local volume_slider = sbar.add("slider", "volume", {
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

local volume_icon = sbar.add("item", "volume_icon", {
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

local function details_on(env)
    sbar.animate("tanh", 30, function()
        volume_slider:set { slider = { width = 100 } }
    end)
end
local function details_off(env)
    sbar.animate("tanh", 30, function()
        volume_slider:set { slider = { width = 0 } }
    end)
end

volume_slider:subscribe("volume_change", function(env)
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
    volume_icon:set { label = icon }
    volume_slider:set { slider = { percentage = percentage } }
    local info = helpers.runcmd("bottombar --query " .. env.NAME)
    if info and info["slider"] and tonumber(info.slider.width) == 0 then
        sbar.animate("tanh", 30, function()
            volume_slider:set { slider = { width = 100 } }
        end)
    end

    os.execute "sleep 2"
    info = helpers.runcmd("bottombar --query " .. env.NAME)
    if info and info["slider"] and info.slider.percentage == env.INFO then
        sbar.animate("tanh", 30, function()
            volume_slider:set { slider = { width = 0 } }
        end)
    end
end)
volume_slider:subscribe("mouse.clicked", function(env)
    os.execute('osascript -e "set volume output volume ' .. env.PERCENTAGE .. '"')
end)

volume_icon:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "right" or env.MODIFIER == "shift" then
        os.execute "bottombar --remove '/volume.device.*/'"
        volume_slider:set { popup = { drawing = "toggle" } }
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
                    position = "popup." .. volume_slider.name,
                    label = {
                        string = device .. "    ",
                        color = color,
                    },
                    click_script = click_script,
                })
                idx = idx + 1
            end
        end
    else
        local info = helpers.runcmd "bottombar --query volume"
        if info and info["slider"] and tonumber(info.slider.width) == 0 then
            details_on(env)
        else
            details_off(env)
        end
    end
end)

volume_icon:subscribe("mouse.exited.global", function()
    volume_slider:set { popup = { drawing = "off" } }
end)

volume_slider:subscribe("mouse.exited.global", function(env)
    details_off(env)
end)
