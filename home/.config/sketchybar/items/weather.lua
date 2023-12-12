local helpers = require "helpers"
local weather = sbar.add("item", "weather", {
    label = {
        align = "center",
    },
    padding_right = -3,
    position = "right",
    update_freq = 1800,
    y_offset = -3,
})

local function update()
    sbar.animate("tanh", 10, function()
        local w = helpers.runcmd('curl -s "https://wttr.in/?format=1"', true)
        if w then
            weather:set { drawing = true, label = w, click_script = "open /System/Applications/Weather.app" }
        else
            weather:set { drawing = false }
        end
    end)
end

weather:subscribe("routine", update)
weather:subscribe("forced", update)

update()
