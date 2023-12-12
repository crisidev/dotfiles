local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"

local mic_slider = sbar.add("slider", "mic", {
    position = "right",
    padding_right = -5,
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

local mic_icon = sbar.add("item", "mic_icon", {
    position = "right",
    padding_right = -5,
    padding_left = 15,
    icon = {
        string = icons.mic.on,
        width = 0,
        align = "left",
        color = colors.white,
        font = {
            style = "Bold",
            size = 19.0,
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
        mic_slider:set { slider = { width = 100 } }
    end)
end
local function details_off(env)
    sbar.animate("tanh", 30, function()
        mic_slider:set { slider = { width = 0 } }
    end)
end
local function update_mute_status()
    local muted = helpers.hammerspoon_result("hs.audiodevice.defaultInputDevice():muted()", true)
    local color = colors.white
    if muted:find "true" then
        color = colors.red
        mic_slider:set { slider = { percentage = 0 } }
    end
    mic_icon:set { icon = { color = color } }
end

mic_icon:subscribe("mic_update", function(env)
    update_mute_status()
end)

mic_icon:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "right" then
        helpers.hammerspoon "spoon.MicMute:toggleMicMute()"
    elseif env.MODIFIER == "shift" then
        os.execute "bottombar --remove '/mic.device.*/'"
        mic_slider:set { popup = { drawing = "toggle" } }
        local current = helpers.runcmd("SwitchAudioSource -t input -c", true)
        local devices = helpers.runcmd "SwitchAudioSource -a -t input"
        if devices then
            local idx = 0
            for device in devices:gmatch "[^\r\n]+" do
                local color = colors.grey
                if device == current then
                    color = colors.white
                end
                local click_script = string.format(
                    "SwitchAudioSource -s \"%s\" && bottombar --set '/mic.device.*/' label.color=%s --set %s label.color=%s --set %s popup.drawing=off",
                    device,
                    colors.grey,
                    "input.device." .. tostring(idx),
                    colors.white,
                    env.NAME
                )
                sbar.add("item", "mic.device." .. tostring(idx), {
                    position = "popup." .. mic_slider.name,
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
        local current = helpers.runcmd 'osascript -e "input volume of (get volume settings)"'
        mic_slider:set { slider = { percentage = current } }
        local info = helpers.runcmd "bottombar --query mic"
        if tonumber(info.slider.width) == 0 then
            details_on(env)
        else
            details_off(env)
        end
    end
    update_mute_status()
end)

mic_slider:subscribe("mouse.clicked", function(env)
    os.execute('osascript -e "set volume input volume ' .. env.PERCENTAGE .. '"')
end)

mic_icon:subscribe("mouse.exited.global", function(env)
    mic_slider:set { popup = { drawing = "off" } }
    details_off(env)
end)

mic_slider:subscribe("mouse.exited.global", function(env)
    details_off(env)
end)

update_mute_status()
