local icons = require "icons"
local colors = require "colors"
local helpers = require "helpers"
local module = {}

module.mic_slider = sbar.add("slider", "mic", {
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

module.mic_icon = sbar.add("item", "mic_icon", {
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

local function update_mute_status()
    local muted = helpers.hammerspoon_result("hs.audiodevice.defaultInputDevice():muted()", true)
    local color = colors.white
    if muted and muted:find "true" then
        color = colors.red
        module.mic_slider:set { slider = { percentage = 0 } }
    end
    module.mic_icon:set { icon = { color = color } }
end

local function update_available_devices(env)
    os.execute "bottombar --remove '/mic.device.*/'"
    module.mic_slider:set { popup = { drawing = "toggle" } }
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
                position = "popup." .. module.mic_slider.name,
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

local function update_slider()
    local current = helpers.runcmd 'osascript -e "input volume of (get volume settings)"'
    module.mic_slider:set { slider = { percentage = current } }
    local info = sbar.query "mic"
    if info then
        if tonumber(info.slider.width) == 0 then
            helpers.slider_on(module.mic_slider, "sin", 20)
        else
            helpers.slider_off(module.mic_slider, "sin", 20)
        end
    else
        helpers.slider_off(module.mic_slider, "sin", 20)
    end
end

-- module.mic_slider:subscribe("volume_change", function(env)
--     local current = helpers.runcmd 'osascript -e "input volume of (get volume settings)"'
--     module.mic_slider:set { slider = { percentage = current } }
--     helpers.slider_on(module.mic_slider, "tanh", 30)
--     os.execute "sleep 1"
--     helpers.slider_off(module.mic_slider, "tanh", 30)
-- end)

module.mic_slider:subscribe("mouse.clicked", function(env)
    os.execute('osascript -e "set volume input volume ' .. env.PERCENTAGE .. '"')
end)

module.mic_slider:subscribe("mouse.exited", function(env)
    helpers.slider_off(module.mic_slider, "sin", 20)
end)

module.mic_icon:subscribe("mic_update", function(env)
    update_mute_status()
end)

module.mic_icon:subscribe("mouse.exited.global", function(env)
    module.mic_slider:set { popup = { drawing = "off" } }
    helpers.slider_off(module.mic_slider, "sin", 20)
end)

module.mic_icon:subscribe("mouse.clicked", function(env)
    if env.MODIFIER == "shift" and env.BUTTON == "left" then
        update_available_devices(env)
    elseif env.BUTTON == "right" then
        helpers.hammerspoon "spoon.MicMute:toggleMicMute()"
    elseif env.BUTTON == "left" then
        update_slider()
    end
    update_mute_status()
end)
